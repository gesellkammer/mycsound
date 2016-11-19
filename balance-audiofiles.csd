<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1



instr 1
	kphase init 0
	idur = ftlen(1) / ftsr(1)
	
	a1	loscil 1, 1, 1, 1
	a2	loscil 1, 1, 2, 1
	a3	balance	a1, a2
	outs a3, a2
		
	kphase	phasor 1/idur, 0
	if kphase >= 0.999 then
		event "i", 2, 0, 1
	endif	
endin

instr 2
	exitnow
endin


</CsInstruments>
<CsScore>
f1 0 0 1 "/Users/edu/proj/presentation-freiburg/double-sketch-plus-audio-30s_00.wav" 0 0 0
f2 0 0 1 "/Users/edu/proj/presentation-freiburg/double-sketch-plus-audio-30s_01.wav" 0 0 0
i1	0 3600

</CsScore>
</CsoundSynthesizer><bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>606</x>
 <y>44</y>
 <width>663</width>
 <height>972</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>231</r>
  <g>46</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBGraph">
  <objectName/>
  <x>9</x>
  <y>5</y>
  <width>700</width>
  <height>277</height>
  <uuid>{e6f23ec4-3280-4ff8-8eae-9e0021c14c3c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <value>0</value>
  <objectName2/>
  <zoomx>1.00000000</zoomx>
  <zoomy>1.00000000</zoomy>
  <dispx>1.00000000</dispx>
  <dispy>1.00000000</dispy>
  <modex>lin</modex>
  <modey>lin</modey>
  <all>true</all>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
<MacGUI>
ioView nobackground {59367, 11822, 65535}
ioGraph {9, 5} {700, 277} table 0.000000 1.000000 
</MacGUI>
