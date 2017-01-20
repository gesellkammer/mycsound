<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 128
nchnls = 2
0dbfs = 1.0

instr 1
  a0 pinker
  aenv fa_tadsr ktrig, 0.5, 0.1, 1, 0.5
  chout 1, a0*aenv
endin

</CsInstruments>
<CsScore>
i 1 0 40

</CsScore>
</CsoundSynthesizer>

