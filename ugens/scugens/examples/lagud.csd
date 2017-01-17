<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 128
nchnls = 2
0dbfs = 1.0

instr 1
	kx = randh(2, 1)
  kx2 = sc_lagud(kx, 1.0, 0.1, 1)
  printks "x %f  x2 %f\n", 0.1, kx, kx2
endin

instr 2
  kmidis[] array 60, 65, 60, 65, 60
  ilen = lenarray(kmidis)
  kidx = int(linseg(0, ilen*2, ilen-0.00000001))
  afreq = upsamp(mtof(kmidis[kidx]))
  afreq2 sc_lagud afreq, 1, 0.1, 1
  a0 = oscili(0.7, afreq2)
  outch 1, a0 
endin

</CsInstruments>
<CsScore>
; i 1 0 10
i 2 0 12

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
