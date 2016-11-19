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
	kzeros0, kperiods, kfreq0_raw init 0, 0, 0
	kmin0 init 1
	kmax0 init 0
	
	iperdur = ksmps/sr
	
	kwindow = invalue("window_ms") / 1000
	ksmooth = invalue("smooth_ms") / 1000
	
	kperiods_thresh = int(kwindow / iperdur)
	kperiods_minmax = int(kperiods_thresh * 10)
	kv0 = gkV0
	kv1 = gkV1

	kperiods = kperiods + 1
	if (kv0 < kmin0) then
		kmin0 = kv0
	elseif (kv0 > kmax0) then
		kmax0 = kv0
	endif
	
	kthresh0 = (kmax0 + kmin0) * 0.5
	
	kzero0 = trigger(kv0, kthresh0, 2)
	if (kzero0 == 1) && (kmax0 - kmin0 > 0.1) then
		kzeros0 = kzeros0 + 1
	endif
	
	if (kperiods % kperiods_thresh == 0) then
		kfreq0_raw = kzeros0 / (kperiods_thresh * iperdur)
		kzeros0 = 0
	endif
	
	if (kperiods % kperiods_minmax == 0) then
		kmin0 = kv0
		kmax0 = kv0
	endif	
	
	kfreq0 = portk(kfreq0_raw, ksmooth)
	printk 0.1, (kmax0 - kmin0)
	
	
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
  <objectName>window_ms</objectName>
  <x>7</x>
  <y>9</y>
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
  <value>60</value>
 </bsbObject>
 <bsbObject version="2" type="BSBSpinBox">
  <objectName>smooth_ms</objectName>
  <x>7</x>
  <y>38</y>
  <width>80</width>
  <height>25</height>
  <uuid>{1ce39551-3f22-4240-955f-25ab30a9370d}</uuid>
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
  <value>10</value>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
