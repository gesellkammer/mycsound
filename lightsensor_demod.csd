<CsoundSynthesizer>

<CsOptions>

</CsOptions>
;--opcode-lib=serialOpcodes.dylib -odac
<CsInstruments>

; this supports a samplerate of up to 3000 Hz 
; through the serial bus
ksmps  = 10
nchnls = 2
0dbfs  = 1
sr     = 44100

#define SAW #1#

giSine    ftgen     0, 0, 2^10, 10, 1

gkV0 init 0
gkV1 init 0


instr 1
	; how could we autoconnect?
	iSerial serialBegin     "/dev/tty.usbmodem1d11", 256000
	kVal  serialRead iSerial
	if( kVal >= 128 ) then
		gkV0 = (serialRead(iSerial) * 128 + serialRead(iSerial)) / 1023.0
		gkV1 = (serialRead(iSerial) * 128 + serialRead(iSerial)) / 1023.0
	endif
endin

instr 2
	kzeros0, kperiods, kfreq0_raw, kthresh0_raw init 0, 0, 0, 0
	kmin0 init 1
	kmax0 init 0

	iperdur = ksmps/sr
	kthresh0_raw = invalue("thresh0")
	kthresh0 = (kmax0 + kmin0) * 0.5
	kwindow = invalue("window_ms") / 1000
	ksmooth = invalue("smooth_ms") / 1000
	
	kperiods_thresh = kwindow / iperdur
	kv0 = gkV0
	kv1 = gkV1
	
	if kv0 < kmin0 then
		kmin0 = kv0
	elseif kv0 > kmax0 then
		kmax0 = kv0
	endif
	
	kperiods = kperiods + 1

	kzero0 = trigger(kv0, kthresh0, 2)
	if kzero0 == 1 then
		kzeros0 = kzeros0 + 1
	endif
	
	if kperiods > kperiods_thresh then
		kfreq0_raw = kzeros0 / (kperiods_thresh * iperdur)
		kzeros0 = 0
		kperiods = 0
		kmin0 = kv0
		kmax0 = kv0
	endif
	;kfreq0 = portk(kfreq0_raw, ksmooth)
	kfreq0 = port(kfreq0_raw, 0.01)
	outvalue "disp1", kthresh0
	
	
	a0 vco2 1, kfreq0*3, 4, 0.00001
	aL = a0 * kv0
	aR = a0 * kv1
	
	
	
	outs a0, a0
	
endin




</CsInstruments>
<CsScore>
i 1 0 3600
i 2 0 3600
e
</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>0</y>
 <width>0</width>
 <height>0</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBSpinBox">
  <objectName>thresh0</objectName>
  <x>208</x>
  <y>8</y>
  <width>80</width>
  <height>25</height>
  <uuid>{f6f156f9-ebd4-4a64-a8e3-d9de2266c099}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <resolution>0.00100000</resolution>
  <minimum>-1e+12</minimum>
  <maximum>1e+12</maximum>
  <randomizable group="0">false</randomizable>
  <value>0.5</value>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>thresh0</objectName>
  <x>107</x>
  <y>8</y>
  <width>100</width>
  <height>25</height>
  <uuid>{e1378e76-9651-49bd-889a-39999804387a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>thresh0</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.50000000</xValue>
  <yValue>0.50000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBSpinBox">
  <objectName>window_ms</objectName>
  <x>109</x>
  <y>47</y>
  <width>80</width>
  <height>25</height>
  <uuid>{0c9a77f8-20de-4e65-a1a6-d47d6f9dd9fd}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <alignment>left</alignment>
  <font>Consolas</font>
  <fontsize>12</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <resolution>0.00000000</resolution>
  <minimum>-1e+12</minimum>
  <maximum>1e+12</maximum>
  <randomizable group="0">false</randomizable>
  <value>50</value>
 </bsbObject>
 <bsbObject version="2" type="BSBSpinBox">
  <objectName>smooth_ms</objectName>
  <x>109</x>
  <y>87</y>
  <width>80</width>
  <height>25</height>
  <uuid>{d8dfac56-3007-4d5c-980d-bd297f9488a0}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <alignment>left</alignment>
  <font>Consolas</font>
  <fontsize>12</fontsize>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <resolution>0.00000000</resolution>
  <minimum>-1e+12</minimum>
  <maximum>1e+12</maximum>
  <randomizable group="0">false</randomizable>
  <value>2</value>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>10</x>
  <y>46</y>
  <width>92</width>
  <height>26</height>
  <uuid>{5bde340a-be4a-479c-adce-a9dfe0c7c00f}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>window (ms)</label>
  <alignment>left</alignment>
  <font>Helvetica Neue</font>
  <fontsize>14</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>10</x>
  <y>85</y>
  <width>94</width>
  <height>29</height>
  <uuid>{40b87da5-84be-405c-b799-b6b37fcf6513}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>smooth (ms)</label>
  <alignment>left</alignment>
  <font>Helvetica Neue</font>
  <fontsize>14</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>10</x>
  <y>7</y>
  <width>92</width>
  <height>26</height>
  <uuid>{80a38b34-5c2f-42d3-ba61-33480d78c147}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>thresh0</label>
  <alignment>left</alignment>
  <font>Helvetica Neue</font>
  <fontsize>14</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBDisplay">
  <objectName>disp1</objectName>
  <x>56</x>
  <y>156</y>
  <width>80</width>
  <height>25</height>
  <uuid>{e966c5e7-4cc3-4224-898a-b5706cae1d1c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>0.035</label>
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
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
