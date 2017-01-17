<CsoundSynthesizer>
<CsOptions>
-b 512 -B 1024 -o dac -i adc -+rtaudio=coreaudio  -d ;;;RT audio I/O with MIDI
</CsOptions>
<CsInstruments>

; Initialize the global variables.
sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

gk_position init 0

instr 1
	event_i "i", 10, 0, 360, 1, 1, 30
	turnoff2 10, 1, 0.2
	turnoff
endin

instr 2
	gk_timescale invalue "timescale"
endin

; Instrument #10  
instr 10
	idur, itab, itimescale, ioffset passign 3
	ilock = 1
	ipitch = 1
	ktimescale init itimescale
	iamp = 1
	iphase = ioffset / idur
	ktrig_timescale changed gk_timescale
	if (ktrig_timescale == 1) then
		ktimescale = gk_timescale
	endif
	aphase	phasor 1/(idur * ktimescale), iphase
	kenv	linenr iamp, 0.2, 0.2, 0.01
	atime = aphase * idur
	a1        mincer atime,kenv,ipitch,itab,ilock
    out a1
endin

</CsInstruments>
<CsScore>
f 1 0 0 1 "/Users/edu/Audio/Samples/jean-paul-sartre-fragment-M.aiff" 0 0 0
i 10 0 360 1 1 0
i 2  0 3600


</CsScore> 
</CsoundSynthesizer><bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>1569</x>
 <y>128</y>
 <width>696</width>
 <height>590</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>231</r>
  <g>46</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBButton">
  <objectName>button1</objectName>
  <x>174</x>
  <y>117</y>
  <width>100</width>
  <height>30</height>
  <uuid>{4d4f4709-e35a-49b4-8c71-15a5d8ea789a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <type>event</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>New Button</text>
  <image>/</image>
  <eventLine>i1 0 10</eventLine>
  <latch>false</latch>
  <latched>false</latched>
 </bsbObject>
 <bsbObject version="2" type="BSBScrollNumber">
  <objectName>timescale</objectName>
  <x>182</x>
  <y>215</y>
  <width>80</width>
  <height>25</height>
  <uuid>{75190bac-8af2-4538-8a41-2aedd19fcd5c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="background">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <value>1.54400000</value>
  <resolution>0.00100000</resolution>
  <minimum>-999999999999.00000000</minimum>
  <maximum>999999999999.00000000</maximum>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
  <randomizable group="0">false</randomizable>
  <mouseControl act="continuous"/>
 </bsbObject>
 <bsbObject version="2" type="BSBLineEdit">
  <objectName>offset</objectName>
  <x>148</x>
  <y>287</y>
  <width>100</width>
  <height>25</height>
  <uuid>{5b842027-a7f0-4127-b872-76d55825fce7}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>0.026</label>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>232</r>
   <g>232</g>
   <b>232</b>
  </bgcolor>
  <background>nobackground</background>
 </bsbObject>
 <bsbObject version="2" type="BSBScrollNumber">
  <objectName>offset</objectName>
  <x>280</x>
  <y>218</y>
  <width>80</width>
  <height>25</height>
  <uuid>{b88d79a6-b54b-4e6d-bc40-10f70e2c4e99}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="background">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <value>0.02600000</value>
  <resolution>0.00100000</resolution>
  <minimum>-999999999999.00000000</minimum>
  <maximum>999999999999.00000000</maximum>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
  <randomizable group="0">false</randomizable>
  <mouseControl act=""/>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
<MacOptions>
Version: 3
Render: Real
Ask: Yes
Functions: ioObject
Listing: Window
WindowBounds: 1569 -112 696 590
CurrentView: io
IOViewEdit: On
Options:
</MacOptions>
<MacGUI>
ioView nobackground {59367, 11822, 65535}
ioButton {174, 117} {100, 30} event 1.000000 "button1" "New Button" "/" i1 0 10
ioText {182, 215} {80, 25} scroll 1.544000 0.001000 "timescale" left "Arial" 10 {0, 0, 0} {65280, 65280, 65280} background noborder 0.58700000
ioText {148, 287} {100, 25} edit 0.026000 0.00100 "offset"  "Arial" 10 {0, 0, 0} {65280, 65280, 65280} falsenoborder 0.026
ioText {280, 218} {80, 25} scroll 0.026000 0.001000 "offset" left "Arial" 10 {0, 0, 0} {65280, 65280, 65280} background noborder 1.96700000
</MacGUI>
