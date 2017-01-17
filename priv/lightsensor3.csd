<CsoundSynthesizer>
<Cabbage>
form caption("Moire"),pos(0,0),size(554, 535)
rslider chan("speedperiod_ms"), bounds(32, 20, 80, 83),  text("WINDOW"), pos(19, 16), size(80, 80), min(5.00000000), max(100.00000000), value(30.33333333), midiCtrl("0,0")
rslider chan("smooth_ms"), bounds(118, 20, 80, 83),  text("SMOOTH"), pos(19, 16), size(80, 80), min(1.00000000), max(50), value(7.1), midiCtrl("0,0")
</Cabbage>

<CsOptions>
-odac 
-b256 
-B512

</CsOptions>
;--opcode-lib=serialOpcodes.dylib -odac
;--omacro:ARDUINO="/dev/tty.usbmodem1a21"
<CsInstruments>

; ksmps  = 16   ; this equals a control samplerate of 2600 Hz at 44100
ksmps  = 32   ; this equals a control samplerate of 1300 Hz at 44100
nchnls = 2
0dbfs  = 1
sr     = 44100

#define ADAPTPERIODX #10#
#define SAW #1#
#define ARDUINO #"/dev/tty.usbmodem1a21"#

giSine    ftgen     0, 0, 2^10, 10, 1

gkV0 init 0
gkV1 init 0
gkFreq init 0
gaFreq init 0

gk_speedwindow  init 0.030
gk_minvariation init 0.1
gk_smooth       init 0.005

giSerial serialBegin $ARDUINO, 115200

alwayson "ReadSerial"
alwayson "CalculateSpeed"
alwayson "UI_qt"

alwayson "Debug"

instr 1
	serialFlush giSerial
endin

instr ReadSerial
	; a script should detect the serial port and call csound with --omacro:ARDUINO="/path/to/serial"
	kVal  serialRead giSerial
	if( kVal >= 128 ) then
		gkV0 = (serialRead(giSerial) * 128 + serialRead(giSerial)) / 1023.0
		gkV1 = (serialRead(giSerial) * 128 + serialRead(giSerial)) / 1023.0
	endif
endin

instr UI_qt
	iperdur = ksmps/sr
	kcounter init 0
	kcounter += 1
	gk_speedwindow  = chnget("speedperiod_ms") / 1000
	gk_minvariation = chnget("minvariation")
	gk_smooth       = chnget("smooth_ms") / 1000
	kuifreq = port(gkFreq, 0.2)
	if( kcounter % 100 == 0 ) then
		chnset  kuifreq, "freq"
	endif
	
endin

instr CalculateSpeed
	i_amptable ftgen 0, 0, -1001, 7,   0, 1, 0, 4, 0.001, 11, 0.063095734448, 4, 1, 980, 1
	iperdur = ksmps/sr
	kzeros0, kperiods, kfreq0_raw, kfreq1_raw init 0
	kmin0, kmin1 init 1
	kmax0, kmax1 init 0
	
	k_speedwindow = max(gk_speedwindow, 0.001)
	k_speedwindow_ks = int(k_speedwindow / iperdur)
	
	kminvariation = gk_minvariation
	
	kv0 = gkV0
	kv1 = gkV1
	
	kmin0 min kmin0, kv0
	kmax0 max kmax0, kv0
	kmin1 min kmin1, kv1
	kmax1 max kmax1, kv1
	
	kthresh0 = (kmax0 + kmin0) * 0.5
	kthresh1 = (kmax1 + kmin1) * 0.5
	
	kzero0 = trigger(kv0, kthresh0, 2)  ; 0=raising, 1=falling, 2=both
	kzero1 = trigger(kv1, kthresh1, 2)  ; 0=raising, 1=falling, 2=both
	
	kthreshok0 = (kmax0 - kmin0 > kminvariation ? 1 : 0)
	kthreshok1 = (kmax1 - kmin1 > kminvariation ? 1 : 0)

	kzeros0 += kzero0 * kthreshok0
	kzeros1 += kzero1 * kthreshok1
	
	if (kperiods % k_speedwindow_ks == 0) then
		kfreq0_raw = kzeros0 / k_speedwindow
		kfreq1_raw = kzeros1 / k_speedwindow
		kzeros0 = 0
		kzeros1 = 0
	endif
	
	k_minmax_ks = k_speedwindow_ks * $ADAPTPERIODX
	if (kperiods % k_minmax_ks == 0) then
		kmin0 = kv0
		kmax0 = kv0
		kmin1 = kv1
		kmax1 = kv1		
	endif	
	
	kfreq  = portk((kfreq0_raw+kfreq1_raw)*0.5, gk_smooth)
	gkFreq = kfreq
	gaFreq interp kfreq
	
	kperiods += 1
	
	; printk 0.1, kfreq
endin

instr Debug
	a1 vco2 1, gkFreq, 4
	outs a1*gkV0, a1*gkV1
	printk 0.2, gkV0
	printk 0.2, gkV1
	printk 0.2, gkFreq
endin

</CsInstruments>
<CsScore>
; i 1 0 3600
; i 2 0 3600
i 1 0 0.01
f0 36000
e
</CsScore>
</CsoundSynthesizer>



<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>448</x>
 <y>1236</y>
 <width>628</width>
 <height>533</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>93</r>
  <g>93</g>
  <b>93</b>
 </bgcolor>
 <bsbObject version="2" type="BSBSpinBox">
  <objectName>speedperiod_ms</objectName>
  <x>142</x>
  <y>15</y>
  <width>65</width>
  <height>23</height>
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
  <minimum>5</minimum>
  <maximum>100</maximum>
  <randomizable group="0">false</randomizable>
  <value>30.3333</value>
 </bsbObject>
 <bsbObject version="2" type="BSBDisplay">
  <objectName>freq</objectName>
  <x>389</x>
  <y>123</y>
  <width>54</width>
  <height>25</height>
  <uuid>{120a6f06-7892-4818-868d-7c24f4ef2bf2}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>0.000</label>
  <alignment>left</alignment>
  <font>Consolas</font>
  <fontsize>12</fontsize>
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
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>213</x>
  <y>16</y>
  <width>158</width>
  <height>23</height>
  <uuid>{f7a3e7b0-8171-470e-95d8-ea039d8bb2be}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>speed update window (ms)</label>
  <alignment>left</alignment>
  <font>Helvetica</font>
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
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>212</x>
  <y>95</y>
  <width>161</width>
  <height>23</height>
  <uuid>{fef07fb7-a63b-4bb8-ba71-3af4d030cec4}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>speed smoothing (ms)</label>
  <alignment>left</alignment>
  <font>Helvetica</font>
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
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBHSlider">
  <objectName>speedperiod_ms</objectName>
  <x>19</x>
  <y>16</y>
  <width>120</width>
  <height>20</height>
  <uuid>{3cee2201-2c43-4ed7-a47e-8a59181386c1}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>5.00000000</minimum>
  <maximum>100.00000000</maximum>
  <value>30.33333333</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBHSlider">
  <objectName>smooth_ms</objectName>
  <x>19</x>
  <y>98</y>
  <width>120</width>
  <height>20</height>
  <uuid>{4deb9a93-e615-4311-ab5f-fa7d1e9ff48a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>120.00000000</maximum>
  <value>6.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBSpinBox">
  <objectName>smooth_ms</objectName>
  <x>145</x>
  <y>96</y>
  <width>65</width>
  <height>22</height>
  <uuid>{6594f457-3b11-42ec-ab9e-ec0f6d5977f1}</uuid>
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
  <value>6</value>
 </bsbObject>
 <bsbObject version="2" type="BSBScrollNumber">
  <objectName>minvariation</objectName>
  <x>142</x>
  <y>129</y>
  <width>49</width>
  <height>22</height>
  <uuid>{17ba8b92-25a6-453f-bbd7-d63c201b96d9}</uuid>
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
  <bgcolor mode="background">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <value>0.07000000</value>
  <resolution>0.01000000</resolution>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
  <randomizable group="0">false</randomizable>
  <mouseControl act=""/>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>212</x>
  <y>129</y>
  <width>161</width>
  <height>23</height>
  <uuid>{530ed6aa-54ed-4f2c-ada3-4bc72c2388ba}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>variation thresh.</label>
  <alignment>left</alignment>
  <font>Helvetica</font>
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
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>380</x>
  <y>15</y>
  <width>80</width>
  <height>25</height>
  <uuid>{0df57bb4-8306-468c-b58a-a5c7e9b89dcd}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <label>frequency A</label>
  <alignment>left</alignment>
  <font>Helvetica</font>
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
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName/>
  <x>389</x>
  <y>42</y>
  <width>14</width>
  <height>79</height>
  <uuid>{27f1b4fc-4df7-41bd-ae8e-dfc0069c6a64}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>freq</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>400.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000003</yValue>
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
</bsbPanel>
<bsbPresets>
</bsbPresets>
