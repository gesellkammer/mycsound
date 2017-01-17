<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 64
nchnls = 2
0dbfs = 1.0

gk_pitch init 69
gk_bend init 0
ga_bus init 0

opcode f2m,k,k
	kfreq xin
	xout 12 * log2(kfreq/442)+69
endop

instr 1
	kbend invalue "bend"
	kbend = port(kbend, 0.1)
	kfreq = cpsmidinn(gk_pitch)
	kuntuned = kfreq * (1+kbend) 
	a0 = oscili(1, kuntuned) * 0.7
	ga_bus += a0
endin

instr 2
	a0 = ga_bus
	kfreq init 442
	kbend0 init 0
	kfreq, kamp ptrack a0, 2048
	kdeltafreq = cpsmidinn(gk_pitch) - kfreq 
	ifftsize = 1024
	ioverlap = ifftsize / 4
	iwinsize = ifftsize
	iwinshape = 1; von-Hann window 
	kdeltapitch = gk_pitch - f2m(kfreq)
	kpitchscale = port(cpsmidinn(gk_pitch) / kfreq, 0.1)
	fftin pvsanal a0, ifftsize, ioverlap, iwinsize, iwinshape
	fftscale pvscale fftin, kpitchscale 
	aout pvsynth fftscale
	kcorrected, kamp ptrack aout, 2048
	printk2 kcorrected
	outch 1, aout
	outch 2, a0
endin

instr 100
	clear ga_bus
endin



</CsInstruments>
<CsScore>
i1 0 3600
i2 1 3600
i100 0 3600
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
 <bsbObject type="BSBVSlider" version="2">
  <objectName>bend</objectName>
  <x>80</x>
  <y>40</y>
  <width>20</width>
  <height>300</height>
  <uuid>{8ef16449-b3bd-45ec-81cf-3e4e23e8a8ec}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>-1.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.14000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
