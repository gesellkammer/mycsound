<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr     = 44100
ksmps  = 64
nchnls = 2
0dbfs = 1

opcode expgate, ak, akkjj
	a0, kthreshdb, kexp, iatt, irel xin
	iatt = iatt >= 0 ? iatt : 0.001
	irel = irel >= 0 ? irel : 0.002
	ilook = iatt * 1
	k0 = kthreshdb - 30
	kx0 = ampdb(k0)
	ky0 = limit(ampdb(k0 - (kthreshdb-k0)*2), 0, 1)
	ky1 = ampdb(kthreshdb)
	kx1 = ky1
	kamp = rms(a0)
	kgain2 init 0
	if( kamp < kx0 ) then
		kgain = 3.1622776601683795e-05  ;; -90 dB
	elseif (kamp < kx1) then
		kamp2 = ky0 + (ky1 - ky0) * ((kamp - kx0)/(kx1 - kx0))
		kgain = pow(kamp2 / kamp, kexp)
	else
		kgain = 1
	endif
	ktime = port(kgain > kgain2 ? iatt : irel, 0.001)
	kgain2 = portk(kgain, ktime)
	a0 *= interp(kgain2)
	a0 delay a0, ilook
	xout a0, kgain2
endop

instr 1
	a0 inch 1
	a1, kgain expgate a0, -30, 70
	printk 0.2, dbamp(rms(a0))
	outch 1, a1
endin


</CsInstruments>
<CsScore>
i1 0 3600
</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>280</x>
 <y>431</y>
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
