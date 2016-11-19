<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 48000
ksmps = 64
nchnls = 2
0dbfs = 1

; gi_sin    ftgen 0, 0, 32768, 10, 1  ; a sine tone
; gi_linear ftgen 0, 0, 1024, -27,  0,0, 500,1, 1000,0 ;; a bpf

instr 1
endin

</CsInstruments>
<CsScore>
;; f1 0 16384 10 1 ; a sine tone
;; f0 3600         ; run for 1 hour

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
