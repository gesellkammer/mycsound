<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 128
nchnls = 2
0dbfs = 1.0

instr 1
    k1 = ntom("4Eb-31")
    printk2 k1
    i0  ntom "4C+"
    print i0
    i1 = ntom:i("4A")
    print i1    
turnoff
endin

</CsInstruments>
<CsScore>
i 1 0 10

</CsScore>
</CsoundSynthesizer>
