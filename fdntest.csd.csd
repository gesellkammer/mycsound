<CsoundSynthesizer>
<CsOptions>
-b512
-B1024
-iadc 
-odac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

opcode fdn, a, akkkkkjjjjj
	;; kgain: 0-1, kdelaytime: 0.002-0.5
	;; kcutoff: cutoff of lowpass filter at output of delay line
	;; kfreq: frequency of random noise
	;; pitchmod: amplitude of random noise (0-10)
	;; tapmix: 0=only feedback, 1=only delay
	;; delratio: a multiplier to the delays
	;; delmin: minimum delay
	;; delmax: maximum delay
	;; cutoffdev: deviation of the cutoff, as a ratio, for each feedback loop
	ain, kgain, kdelaytime, kcutoff, kfreq, kpitchmod, i_tapmix, i_delratio, i_delmin, i_delmax, i_cutoffdev xin
	itapmix = i_tapmix >= 0 ? i_tapmix : 0.2
	ifiltgain = 1 - itapmix
	itapgain = itapmix
	idelratio = (i_delratio >= 0 ? i_delratio : 1)
	idelmin = (i_delmin >= 0 ? i_delmin : 0.0663) * idelratio
	idelmax = (i_delmax >= 0 ? i_delmax : 0.0971) * idelratio
	idel1 = idelmin
	idel2 = idelmin + (idelmax - idelmin) * 0.34
	idel3 = idelmin + (idelmax - idelmin) * 0.55
	idel4 = idelmax
	icutoffdev = i_cutoffdev >= 0 ? i_cutoffdev : 0.2
	afilt1, afilt2, afilt3, afilt4 init 0	
	kgain *= 0.70710678117
	
	k1 randi .001, 3.1 * kfreq, .06
	k2 randi .0011, 3.5 * kfreq, .9
	k3 randi .0017, 1.11 * kfreq, .7
	k4 randi .0006, 3.973 * kfreq, .3
	
	atap multitap ain, 0.00043, 0.0615, \
	                   0.00268, 0.0298, \ 
					   0.00485, 0.0572, \
					   0.00595, 0.0708, \
					   0.00741, 0.0797, \
					   0.0142, 0.134, \
					   0.0217, 0.181, \
					   0.0272, 0.192, \
					   0.0379, 0.346, \
					   0.0841, 0.504
	adum1 delayr 0.5 
	adel1 deltapi idel1 * kdelaytime + k1*kpitchmod
	delayw ain + afilt2 + afilt3

	adum2 delayr 0.5
	adel2 deltapi idel2 * kdelaytime + k2*kpitchmod
	delayw ain - afilt1 - afilt4
	
	adum3 delayr 0.5
	adel3 deltapi idel3 * kdelaytime + k3*kpitchmod
	delayw ain + afilt1 - afilt4

	adum4 delayr 0.5
	adel4 deltapi idel4 * kdelaytime + k4*kpitchmod
	delayw ain + afilt2 - afilt3

	afilt1 tone adel1*kgain, kcutoff * (1 - icutoffdev*0.5)
	afilt2 tone adel2*kgain, kcutoff * (1 - icutoffdev*0.167)
	afilt3 tone adel3*kgain, kcutoff * (1 + icutoffdev*0.167)
	afilt4 tone adel4*kgain, kcutoff * (1 + icutoffdev*0.5)

	afilt = sum(afilt1, afilt2, afilt3, afilt4) * 0.70710678117
	aout ntrpol afilt, atap, itapmix
	xout aout
endop

instr 1
	ain inch 2
	ktrig metro 15
	kamp = max_k(ain, ktrig, 1)
	kamp2 = pow(kamp, 0.5)
	kpitchvar = port(scale(kamp2, 0.45, 0.1), 0.005)
	kcutoff = port(scale(kamp2, 12000, 4000), 0.005)
	printk 0.1, kpitchvar
	printk 0.1, kcutoff
	;; kpitchvar = 0.5
	kfreq = port(scale(kamp2, 0.7, 0.1), 0.01)
	itapmix = 0.3
	idelratio = 1
	idelmin = 0.06
	idelmax = 0.09
	icutoff = 0.5
	afx = fdn(ain, 0.96, 0.15, kcutoff, kfreq, kpitchvar, itapmix, idelratio, idelmin, idelmax, icutoff)
	;afx butterhp afx, 120
	afx atone afx, 60
	
	; ain, kgain, kdelaytime, kcutoff, kfreq, kpitchmod, i_tapmix, i_delratio, i_delmin, i_delmax, i_cutoffdev xin
	; afx = ain
	afx compress afx, afx, -90, 80, 86, 50, 0.003, 0.05, 0.01
	aout ntrpol ain, afx, 1
	outch 1, aout, 2, aout
endin


</CsInstruments>
<CsScore>
i1 0 3600


</CsScore>
</CsoundSynthesizer>
