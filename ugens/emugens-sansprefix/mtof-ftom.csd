<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 128
nchnls = 2
0dbfs = 1.0
A4

instr 1
    kfreq = mtof(69)
    printks2 "midi 69   -> %f\n", kfreq

    kmidi = ftom(442)
    printks2 "freq 442  -> %f\n", kmidi

    kfreq = mtof(kmidi)
    printks "midi %f -> %f\n", 1, kmidi, kfreq

    imidi = ftom:i(440)
    print imidi

    ifreq = mtof:i(60)
    print ifreq
    

    
    turnoff
endin

</CsInstruments>
<CsScore>
i 1 0 10

</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
