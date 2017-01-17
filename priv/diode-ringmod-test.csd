<CsoundSynthesizer>
<CsOptions>
-+rtaudio=jack
</CsOptions>
<CsInstruments>
sr=48000
ksmps=1
nchnls=2
0dbfs=1


ga_bluemix_1_0	init	0
ga_bluemix_1_1	init	0
ga_bluesub_Master_0	init	0
ga_bluesub_Master_1	init	0


gk_blue_auto0 init 0.5
gk_blue_auto1 init 440
gk_blue_auto2 init 0
gk_blue_auto3 init 0

gkfreq init 440


/*
 Implementation of Julian Parker’s digital model of a Ring
 Modulator. 

 http://kunstmusik.com/2013/09/07/julian-parker-ring-modulator/

 UDO version by Steven Yi
 Original: 2013.09.07
 Revised: 2015.04.07

*/
	opcode ringmod,a,aa

ain, acarrier xin

itab chnget "ringmod.table"

; TABLE INIT

if(itab == 0) then
; generate table according to formula 2 in document
itablen = 2^16
itab ftgen 0, 0, itablen, -2, 0
i_vb = 0.2
i_vl = 0.4
i_h = .1
i_vl_vb_denom = ((2 * i_vl) - (2 * i_vb))
i_vl_add =  i_h * ( ((i_vl - i_vb)^2) / i_vl_vb_denom)
i_h_vl = i_h * i_vl

indx = 0

chnset itab, "ringmod.table"

ihalf = itablen / 2

until (indx >= itablen) do
iv = (indx - ihalf) / ihalf
iv = abs(iv)


if(iv <= i_vb) then
    tableiw 0, indx, itab, 0, 0, 2
elseif(iv <= i_vl) then
    ival = i_h * ( ((iv - i_vb)^2) / i_vl_vb_denom)
    tableiw ival, indx, itab, 0, 0, 2
else
    ival = (i_h * iv) - i_h_vl + i_vl_add
    tableiw ival, indx, itab, 0, 0, 2
endif
indx += 1
od

endif

; END TABLE INIT
ain1 = (ain * .5)
acar2 = acarrier + ain1
ain2 = acarrier - ain1

asig1 table3 acar2, itab, 1, 0.5
asig2 table3 acar2 * -1, itab, 1, 0.5
asig3 table3 ain2, itab, 1, 0.5
asig4 table3 ain2 * -1, itab, 1, 0.5

asiginv = (asig3 + asig4) * -1

aout sum asig1, asig2, asiginv

xout aout

endop

opcode hilbertmod,a,ak

  ain, kfreq xin
  areal, aimag hilbert ain
 
  ; Quadrature oscillator.
  asin oscili 1, kfreq, 1
  acos oscili 1, kfreq, 1, .25
 
  ; Use a trigonometric identity. 
  ; See the references for further details.
  amod1 = areal * acos
  amod2 = aimag * asin

  ; Both sum and difference frequencies can be 
  ; output at once.
  ; aupshift corresponds to the sum frequencies.
  aupshift = (amod1 - amod2) * 0.7
  ; adownshift corresponds to the difference frequencies. 
  adownshift = (amod1 + amod2) * 0.7
  xout aupshift + adownshift
endop



	instr 1	;RingModInstr
ain inch 1

; acar poscil gk_blue_auto0, gk_blue_auto1
gkvol chnget "vol"
gkfreq chnget "freq"
kringdiode chnget "ringdiode"
khilbert chnget "hilbert"
ksine chnget "sine"
acar poscil gkvol, gkfreq

; aringdiode = ringmod(ain, acar)
aringdiode = ain
ahilbert = hilbertmod(ain, gkfreq)
asine = ain * acar
aout = aringdiode * kringdiode + ahilbert * khilbert + asine * ksine

aout limit aout, -0.9, 0.9
outs aout, aout
	endin



</CsInstruments>

<CsScore>


f 1 0 16384 10 1

i1 0.5 3600

e

</CsScore>

</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>0</y>
 <width>258</width>
 <height>415</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>vol</objectName>
  <x>24</x>
  <y>43</y>
  <width>21</width>
  <height>371</height>
  <uuid>{0e399066-2973-47c6-87fb-d1a005ca00b2}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.24797844</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>freq</objectName>
  <x>56</x>
  <y>43</y>
  <width>21</width>
  <height>371</height>
  <uuid>{1a613916-be41-44c6-912e-7b9ff147410a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>6.00000000</minimum>
  <maximum>2000.00000000</maximum>
  <value>1091.68194070</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBSpinBox">
  <objectName>freq</objectName>
  <x>81</x>
  <y>390</y>
  <width>80</width>
  <height>25</height>
  <uuid>{1d324235-63d8-4405-a460-29816f345714}</uuid>
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
  <minimum>0</minimum>
  <maximum>20000</maximum>
  <randomizable group="0">false</randomizable>
  <value>1091.68</value>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>ringdiode</objectName>
  <x>174</x>
  <y>203</y>
  <width>25</width>
  <height>89</height>
  <uuid>{7b252870-6e68-4077-9459-9914665c5f3a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.46067416</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>hilbert</objectName>
  <x>205</x>
  <y>203</y>
  <width>25</width>
  <height>89</height>
  <uuid>{ee8116a9-0076-4e2d-aa22-fa6f65402bb6}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.49438202</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>sine</objectName>
  <x>233</x>
  <y>203</y>
  <width>25</width>
  <height>89</height>
  <uuid>{986fef0b-9d6b-4785-a440-2b72c677f312}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
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
