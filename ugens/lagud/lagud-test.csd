<CsoundSynthesizer>
<CsOptions>
-+rtaudio=jack
-odac

</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 128
nchnls = 2
0dbfs = 1.0

instr 1
    a0 poscil 1, 440
    kenv linseg 0, 0.01, 1, 4, 1, 0.01, 0
    aenv = lagud(a(kenv), 1.5, 1)
    a0 *= aenv
    outs a0, a0
endin

</CsInstruments>
<CsScore>
i 1 0 10


</CsScore>
</CsoundSynthesizer>
