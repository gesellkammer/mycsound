<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-b 256               ; Buffer size. Make it bigger if there are glitches, smaller for shorter latency
-B 512               ; HW Buffer Size. As a rule, the double of the previous value.
-odac                ; use default audio device (OSX: set the audio device in Audio MIDI Setup)
; -+rtaudio=portaudio 
--env:CSNOSTOP=yes   ; dont touch this
--nodisplays        ; suppress wave-form displays
--new-parser        ; use the new-parser for better error reports, if you are using csound >= 5.14
</CsOptions>
<CsInstruments>
sr = 48000          ; sample rate
nchnls = 2          ; number of channels
ksmps = 64          ; block-size in samples. make it bigger if there are x-runs. default=64
0dbfs  = 1          ; dont change this

instr 2
    kgate   metro   1
    ;                              brightness   detuning    hardness    stiffness   reverb  room    pan     width
    a1, a2  piano   440, 1, kgate, 0.0,           0.05,       0.0,        0.28,       0.337,  0.72,   0.5,    0.1
    outs a1, a2
endin
</CsInstruments>
<CsScore>
i 2 0 3600
; f0 36000    ;; run 10 hours
; e

</CsScore>
</CsoundSynthesizer>