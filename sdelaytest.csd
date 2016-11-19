<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr     = 44100
ksmps  = 64
nchnls = 2

instr 1
	ain inch 2
	afx = smoothdelay1(ain, 0.2, 0.9999, 5)
	outch 1, afx
endin

</CsInstruments>
<CsScore>
i1 0 3600

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
