<CsoundSynthesizer>
<CsOptions>
-+rtaudio=jack
-odac
-iadc
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 128
nchnls = 2
0dbfs = 1.0

#define _(label'x) #$x#

gitab ftgen 0,0,0,-1,"/home/em/proj/slidesynth/csound/assets/airpump2-48k-L.wav",0,0,0

opcode loop,a,iikki
	; krate0 y krate1 pueden ser diferentes para generar jitter
	ifn, itaildur, krate0, krate1, iratesmooth xin
	ifadedur = 0.100
	irate0 = i(krate0)
	kratejit = port(random(krate0, krate1), iratesmooth, irate0)
	kreleasing release
	kratebase linseg 0.5, ifadedur, 1, 999999, 1
	krate = port(kratebase*kratejit, iratesmooth, irate0)
	printk2 krate
	a0 loscil $_(amp'1), $_(rate'krate), ifn, 1, \
		$_(imod1'-1), $_(imod2'-1)
	aenv linenr 1, 0.1, itaildur, 1
	if kreleasing == 1 kgoto releasing
	a0 *= aenv
	kgoto done
releasing:
	aenv *= linseg(1, itaildur-ifadedur, 1, ifadedur, 0)
done:
	xout a0
endop 

instr 1
	a0 loop gitab, 4.5, 0.9, 1, 0.10
	outch 1, a0
endin
</CsInstruments>
<CsScore>
i 1 0 10000
f 0 3600
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
<EventPanel name="" tempo="60.00000000" loop="8.00000000" x="878" y="181" width="655" height="346" visible="true" loopStart="0" loopEnd="0">i -1 0 1 </EventPanel>
<EventPanel name="" tempo="60.00000000" loop="8.00000000" x="830" y="351" width="655" height="346" visible="false" loopStart="0" loopEnd="0">i -1 0 1 </EventPanel>
