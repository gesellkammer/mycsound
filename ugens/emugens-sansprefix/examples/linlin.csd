<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 128
nchnls = 2
0dbfs = 1.0

instr 1
    kx line 2, p3, 3
    ky linlin kx, 1, 3, 0, 10
	printks "kx: %f   ky: %f \n", 1/kr, kx, ky
endin

</CsInstruments>
<CsScore>
i 1 0 1

</CsScore>
</CsoundSynthesizer>

