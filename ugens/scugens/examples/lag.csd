<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 128
nchnls = 2
0dbfs = 1.0

instr 1
	kx = floor(line(0, p3, 10))
	kx2 = sc_lag(kx, 0.01)
	printk2 kx2

endin

instr 2
	kmidi = floor(line(60, p3, 72))
	kfreq = mtof(kmidi)
	afreq = a(kfreq)
	afreq2 sc_lag afreq, 0.1
	a0 = oscili(0.5, afreq2)
	outch 1, a0 
	portk
endin

</CsInstruments>
<CsScore>
i 1 0 5
i 2 0 10

</CsScore>
</CsoundSynthesizer>

linseg
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
