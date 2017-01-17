/*

    scugens.c

*/

#include <math.h>
#include <csdl.h>

#define LOG001 FL(-6.907755278982137)
#define CALCSLOPE(next,prev,nsmps) ((next - prev) * (FL(1)/nsmps))
#define SR (csound->GetSr(csound))

#define LOOP1(length, stmt)			\
	{	int xxn = (length);			\
		do {						\
			stmt;					\
		} while (--xxn);			\
}

inline MYFLT zapgremlins(MYFLT x)
{
	MYFLT absx = abs(x);
	// very small numbers fail the first test, eliminating denormalized numbers
	//    (zero also fails the first test, but that is OK since it returns zero.)
	// very large numbers fail the second test, eliminating infinities
	// Not-a-Numbers fail both tests and are eliminated.
	return (absx > (MYFLT)1e-15 && absx < (MYFLT)1e15) ? x : (MYFLT)0.;
}

/*

  lag

  This is essentially the same as OnePole except that instead of 
  supplying the coefficient directly, it is calculated from a 60 dB lag time. 
  This is the time required for the filter to converge to within 0.01% 
  of a value. This is useful for smoothing out control signals.

  ksmooth = lag(kx, klagtime, [initialvalue=0])
  asmooth = lag(ka, klagtime, [initialvalue=0])
  
*/

typedef struct {
  OPDS    h;
  MYFLT   *out, *in, *lagtime, *first;
  MYFLT   lag, b1, y1;
  MYFLT   sr;
} LAG;

static int lagk_next(CSOUND *csound, LAG *p) {
  MYFLT lag = *p->lagtime;
  MYFLT y0 = *p->in;
  MYFLT y1 = p->y1;
  MYFLT b1;
  if (lag == p->lag) {
	b1 = p->b1;
	p->y1 = y1 = y0 + b1 * (y1 - y0);
	*p->out = y1;
	return OK;
  } else {
	// faust uses tau2pole = exp(-1 / (lag*sr))
	b1 = lag == FL(0) ? FL(0) : exp(LOG001 / (lag * p->sr));
	*p->out = y0 + b1 * (y1 - y0);
	p->lag = lag;
	p->b1 = b1;
	return OK;
  }
}

static int lag_init0(CSOUND *csound, LAG *p) {
  p->lag = -1;
  p->b1 = FL(0);
  p->y1 = *p->first;
  return OK;
}

static int lagk_init(CSOUND *csound, LAG *p) {
  lag_init0(csound, p);
  p->sr = csound->GetKr(csound);
  return lagk_next(csound, p);
}

static int laga_init(CSOUND *csound, LAG *p) {
  lag_init0(csound, p);
  p->sr = csound->GetSr(csound);
  return OK;
}


static int laga_next(CSOUND *csound, LAG *p) {
  uint32_t n, nsmps = CS_KSMPS;
  MYFLT *in = p->in, *out = p->out;
  MYFLT lag = *p->lagtime;
  MYFLT y1 = p->y1;
  MYFLT b1 = p->b1;
  MYFLT y0;
  if (lag == p->lag) {
	LOOP1(nsmps,
		  y0 = *in; in++;
		  y1 = y0 + b1 * (y1 - y0);
		  *out = y1; out++;
		  );
	p->y1 = y1;
	return OK;
  } else {
	// faust uses tau2pole = exp(-1 / (lag*sr))
	p->b1 = lag == FL(0) ? FL(0) : exp(LOG001 / (lag * p->sr));
	MYFLT b1_slope = CALCSLOPE(p->b1, b1, nsmps);
	p->lag = lag;
	LOOP1(nsmps,
		  b1 += b1_slope;
		  y0 = *in; in++;
		  y1 = y0 + b1 * (y1 - y0);
		  *out = y1; out++;
		  );
	p->y1 = y1;
	return OK;
  }
}
 
/*

void Lag_next(Lag *unit, int inNumSamples)
{
	float *out = ZOUT(0);
	float *in = ZIN(0);
	float lag = ZIN0(1);

	double y1 = unit->m_y1;
	double b1 = unit->m_b1;

	if (lag == unit->m_lag) {
		LOOP1(inNumSamples,
			double y0 = ZXP(in);
			ZXP(out) = y1 = y0 + b1 * (y1 - y0);
		);
	} else {
		unit->m_b1 = lag == 0.f ? 0.f : exp(log001 / (lag * unit->mRate->mSampleRate));
		double b1_slope = CALCSLOPE(unit->m_b1, b1);
		unit->m_lag = lag;
		LOOP1(inNumSamples,
			b1 += b1_slope;
			double y0 = ZXP(in);
			ZXP(out) = y1 = y0 + b1 * (y1 - y0);
		);
	}
	unit->m_y1 = zapgremlins(y1);
}

void Lag_next_1(Lag *unit, int inNumSamples)
{
	float *out = OUT(0);
	float *in = IN(0);
	float lag = IN0(1);

	double y1 = unit->m_y1;
	double b1 = unit->m_b1;

	if (lag == unit->m_lag) {
		double y0 = *in;
		*out = y1 = y0 + b1 * (y1 - y0);
	} else {
		unit->m_b1 = b1 = lag == 0.f ? 0.f : exp(log001 / (lag * unit->mRate->mSampleRate));
		unit->m_lag = lag;
		double y0 = *in;
		*out = y1 = y0 + b1 * (y1 - y0);
	}
	unit->m_y1 = zapgremlins(y1);
}

void Lag_Ctor(Lag* unit)
{
	if (BUFLENGTH == 1)
		SETCALC(Lag_next_1);
	else
		SETCALC(Lag_next);

	unit->m_lag = uninitializedControl;
	unit->m_b1 = 0.f;
	unit->m_y1 = ZIN0(0);
	Lag_next(unit, 1);
}
 */


// ------------------------- LagUD ---------------------------

typedef struct {
  OPDS    h;
  MYFLT   *out, *in, *lagtimeU, *lagtimeD, *first;
  MYFLT   lagu, lagd, b1u, b1d, y1;
} LagUD;

/*
struct LagUD : public Unit
{
	float m_lagu, m_lagd;
	double m_b1u, m_b1d, m_y1;
};

*/


static int lagud_a(CSOUND *csound, LagUD *p) {
  MYFLT
	*out = p->out,
	*in = p->in,
	lagu = *p->lagtimeU,
	lagd = *p->lagtimeD,
	y1 = p->y1,
	b1u = p->b1u,
	b1d = p->b1d;
  
  uint32_t nsmps = CS_KSMPS;

  if ((lagu == p->lagu) && (lagd == p->lagd)) {
	LOOP1(nsmps,
		  MYFLT y0 = *in; in++;
		  if (y0 > y1)
			y1 = y0 + b1u * (y1 - y0); 
		  else
			y1 = y0 + b1d * (y1 - y0);
		  *out = y1; out++;
		  );
  } else {
	MYFLT sr = csound->GetSr(csound);
	// faust uses tau2pole = exp(-1 / (lag*sr))
	p->b1u = lagu == FL(0) ? FL(0) : exp(LOG001 / (lagu * sr));
	MYFLT b1u_slope = CALCSLOPE(p->b1u, b1u, nsmps);
	p->lagu = lagu;
	p->b1d = lagd == FL(0) ? FL(0) : exp(LOG001 / (lagd * sr));
	MYFLT b1d_slope = CALCSLOPE(p->b1d, b1d, nsmps);
	p->lagd = lagd;
	LOOP1(nsmps,
		  b1u += b1u_slope;
		  b1d += b1d_slope;
		  MYFLT y0 = *in; in++;
		  if (y0 > y1)
			y1 = y0 + b1u * (y1-y0);
		  else
			y1 = y0 + b1d * (y1-y0);
		  *out = y1; out++;
		  );
  }
  p->y1 = zapgremlins(y1);
  return OK;
}

static int lagud_k(CSOUND *csound, LagUD *p) {
  MYFLT
	*in = p->in,
	lagu = *p->lagtimeU,
	lagd = *p->lagtimeD,
	y1 = p->y1;
  
  uint32_t nsmps = CS_KSMPS;

  if ((lagu == p->lagu) && (lagd == p->lagd)) {
	MYFLT y0 = *in;
	if (y0 > y1)
	  p->y1 = y1 = y0 + p->b1u * (y1 - y0); 
	else
	  p->y1 = y1 = y0 + p->b1d * (y1 - y0);
	*(p->out) = y1;
	
  } else {
	MYFLT sr = csound->GetKr(csound);
	// faust uses tau2pole = exp(-1 / (lag*sr))
	p->b1u = lagu == FL(0) ? FL(0) : exp(LOG001 / (lagu * sr));
	p->lagu = lagu;
	p->b1d = lagd == FL(0) ? FL(0) : exp(LOG001 / (lagd * sr));
	p->lagd = lagd;
	MYFLT y0 = *in;
	if (y0 > y1)
	  y1 = y0 + p->b1u * (y1 - y0);
	else
	  y1 = y0 + p->b1d * (y1 - y0);
	*(p->out) = y1;
  }
  p->y1 = y1;
  return OK;
}

/*
void LagUD_next(LagUD *unit, int inNumSamples)
{
	float *out = ZOUT(0);
	float *in = ZIN(0);
	float lagu = ZIN0(1);
	float lagd = ZIN0(2);

	double y1 = unit->m_y1;
	double b1u = unit->m_b1u;
	double b1d = unit->m_b1d;

	if ( (lagu == unit->m_lagu) && (lagd == unit->m_lagd) ) {
		LOOP1(inNumSamples,
			double y0 = ZXP(in);
			if ( y0 > y1 )
				ZXP(out) = y1 = y0 + b1u * (y1 - y0);
			else
				ZXP(out) = y1 = y0 + b1d * (y1 - y0);
		);
	} else {
		unit->m_b1u = lagu == 0.f ? 0.f : exp(log001 / (lagu * unit->mRate->mSampleRate));
		double b1u_slope = CALCSLOPE(unit->m_b1u, b1u);
		unit->m_lagu = lagu;
		unit->m_b1d = lagd == 0.f ? 0.f : exp(log001 / (lagd * unit->mRate->mSampleRate));
		double b1d_slope = CALCSLOPE(unit->m_b1d, b1d);
		unit->m_lagd = lagd;
		LOOP1(inNumSamples,
		b1u += b1u_slope;
		b1d += b1d_slope;
			double y0 = ZXP(in);
			if ( y0 > y1 )
				ZXP(out) = y1 = y0 + b1u * (y1 - y0);
			else
				ZXP(out) = y1 = y0 + b1d * (y1 - y0);
		);
	}
	unit->m_y1 = zapgremlins(y1);
}
*/

static int lagud_init(CSOUND *csound, LagUD *p) {
  p->lagu = -1;
  p->lagd = -1;
  p->b1u = FL(0);
  p->b1d = FL(0);
  p->y1 = *p->first;
  return OK;
}

/*
void LagUD_Ctor(LagUD* unit)
{
	SETCALC(LagUD_next);

	unit->m_lagu = uninitializedControl;
	unit->m_lagd = uninitializedControl;
	unit->m_b1u = 0.f;
	unit->m_b1d = 0.f;
	unit->m_y1 = ZIN0(0);
	LagUD_next(unit, 1);
}
*/
	
#define S(x)    sizeof(x)

static OENTRY localops[] = {
  { "sc_lag",     S(LAG),   0, 3,   "k", "kko", (SUBR)lagk_init, (SUBR)lagk_next },
  { "sc_lag",     S(LAG),   0, 5,   "a", "ako", (SUBR)laga_init, NULL, (SUBR)laga_next },
  { "sc_lagud",   S(LagUD), 0, 3,   "k", "kkko", (SUBR)lagud_init, (SUBR)lagud_k },
  { "sc_lagud",   S(LagUD), 0, 5,   "a", "akko", (SUBR)lagud_init, NULL, (SUBR)lagud_a }
};


LINKAGE
