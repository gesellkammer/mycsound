<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 128
nchnls = 2
0dbfs = 1.0
instr 1
	ipairs[] array 	-1, 5, 10, 0, 12.34, 1
	ibpf[] bpfgen ipairs, 2  ;; make table with two decimal points precission
	kx = line(-1, p3, 13)
	ky = bpfat(ibpf, kx)
	printks "kx %f   ky %f\n", 0.01, kx, ky
endin

</CsInstruments>
<CsScore>
i1 0 2
	
</CsScore>
</CsoundSynthesizer>
opcode
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
