# Some supercollider ugens ported to csound

## Lag

This is essentially the same as OnePole except that instead of
supplying the coefficient directly, it is calculated from a 60 dB lag
time.
This is the time required for the filter to converge to within 0.01% 
of a value. This is useful for smoothing out control signals.

krate and arate


    ksmooth = lag(kx, klagtime, [initialvalue=0])
    asmooth = lag(ka, klagtime, [initialvalue=0])


## LagUD

The same as Lag but with different lag times for up and down slope


    ksmooth = lagud(kx, klagup, klagdown, [i0=0])
    asmooth = lagud(ax, klagup, klagdown, [i0=0])


## Phasor

A resettable phasor

	aindex = phasor(atrig, xrate, kstart, kend, kresetpos)
	kindex = phasor(ktrig, krate, kstart, kend, kresetpos)

## Trig

Hold a trigger for a given duration

    ktrig = trig(kvalue, kdur)
    atrig = trig(avalue, kdur)


