<CsoundSynthesizer>
<CsOptions>
-iadc -odac -b1024 -B2048 -+rtaudio=jack -+rtmidi=null -m0
</CsOptions>

<CsInstruments>
sr = 48000	
ksmps	= 256	
nchnls = 1		
0dbfs	= 1

alwayson 100
; OSCsend kwhen, ihost, iport, idestination, itype [, kdata1, kdata2, ...]

opcode bandanalyze, a, aik
	iq = 4.318 * 2
	ain, ifreq, ktrig	xin
	aband butterbp ain, ifreq, ifreq/iq
	; krms rms aband, 100
	aenv follow2 aband, 0.05, 0.5
	krms downsamp aenv, 64
	Slabel sprintf "/eq/%d", ifreq
	OSCsend ktrig, "127.0.0.1", 31415, "/print/vu", "sf", Slabel, krms
	xout aband
endop
	
instr 100
	ain	inch 1
	ksend metro 8
	a1 bandanalyze ain, 20, ksend
	a2 bandanalyze ain, 25, ksend
	a3 bandanalyze ain, 31.5, ksend
	a4 bandanalyze ain, 50, ksend
	a4 bandanalyze ain, 63, ksend
	a4 bandanalyze ain, 80, ksend
	a4 bandanalyze ain, 100, ksend
	a4 bandanalyze ain, 125, ksend
	a4 bandanalyze ain, 160, ksend
	a4 bandanalyze ain, 200, ksend
	a4 bandanalyze ain, 250, ksend
	a4 bandanalyze ain, 315, ksend
	a4 bandanalyze ain, 400, ksend
	a4 bandanalyze ain, 500, ksend
	a4 bandanalyze ain, 630, ksend
	a4 bandanalyze ain, 800, ksend
	a4 bandanalyze ain, 1000, ksend
	a4 bandanalyze ain, 1250, ksend
	a4 bandanalyze ain, 1600, ksend
	a4 bandanalyze ain, 2000, ksend
	a4 bandanalyze ain, 2500, ksend
	a4 bandanalyze ain, 3150, ksend
	a4 bandanalyze ain, 4000, ksend
	a4 bandanalyze ain, 5000, ksend
	a4 bandanalyze ain, 6300, ksend
	a4 bandanalyze ain, 8000, ksend
	a4 bandanalyze ain, 10000, ksend
	a4 bandanalyze ain, 12500, ksend
	a4 bandanalyze ain, 16000, ksend	
	a4 bandanalyze ain, 20000, ksend	
endin

</CsInstruments>


<CsScore>
e 3600

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
</bsbPanel>
<bsbPresets>
</bsbPresets>
