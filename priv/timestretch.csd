<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

; Initialize the global variables.
sr = 44100
ksmps = 64
nchnls = 1
0dbfs = 1

instr 1
	idur0, itab, itimescale 	passign 3
	idur = ftlen(itab) / ftsr(itab)
	print idur
	ilock = 0
	ipitch = 1
	iamp = 1
	kphase init 0
	aphase	phasor 1/(idur * itimescale), 0
	kphase downsamp aphase
	printk 0.1, kphase
	if kphase >= 0.999 then
		event "i", 2, 0, 1
	endif
	atime = aphase * idur
	a1		mincer atime,iamp,ipitch,itab,ilock
	out	a1
endin

instr 2
	exitnow
endin

</CsInstruments>
<CsScore>
f1 0 0 1 "/Users/edu/proj/STELLUNG1-AM-TISCH/SAMPLES/NORMALIZED-RMS24/vl-PING-sin-ataques-UP-01.aif" 0 0 0
;  time	duration	table	timescale
i1 0 	3600		1		2
</CsScore>
</CsoundSynthesizer><bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>1253</x>
 <y>44</y>
 <width>663</width>
 <height>950</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>231</r>
  <g>46</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>slider1</objectName>
  <x>5</x>
  <y>5</y>
  <width>20</width>
  <height>100</height>
  <uuid>{edd5b2a4-3b05-4795-bfdf-6d1f2b313f2f}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
<MacGUI>
ioView nobackground {59367, 11822, 65535}
ioSlider {5, 5} {20, 100} 0.000000 1.000000 0.000000 slider1
</MacGUI>
