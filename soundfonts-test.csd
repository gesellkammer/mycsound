<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 100
nchnls = 2

giengine  fluidEngine
isfnum    fluidLoad "/Users/edu/Desktop/stavi_violin.sf2", giengine, 1
          fluidProgramSelect giengine, 1, isfnum, 0, 0

instr 1
          mididefault     60, p3
          midinoteonkey   p4, p5

  ikey    init            p4
  ivel    init            p5

          fluidNote       giengine, 1, ikey + 0.5, ivel ; ikey, ivel
          fluidNote       giengine, 1, ikey, ivel ; ikey, ivel

endin

instr 99
  imvol   init            70000
  asigl, asigr fluidOut   giengine
          outs            asigl * imvol, asigr * imvol
endin 


</CsInstruments>
<CsScore>

i 99 0 200
e
</CsScore>
</CsoundSynthesizer>
<MacOptions>
Version: 3
Render: Real
Ask: Yes
Functions: ioObject
Listing: Window
WindowBounds: -789 -931 289 431
CurrentView: io
IOViewEdit: On
Options: -b128 -A -s -m167 -R
</MacOptions>
<MacGUI>
ioView background {32125, 41634, 41120}
ioSlider {8, 7} {20, 98} 0.000000 1.000000 0.367347 amp
ioSlider {34, 6} {239, 22} 100.000000 1000.000000 100.000000 freq
ioGraph {8, 112} {265, 116} table 0.000000 1.000000 
ioListing {8, 234} {266, 158}
ioText {34, 37} {41, 24} label 0.000000 0.00100 "" left "Lucida Grande" 8 {0, 0, 0} {65280, 65280, 65280} background noborder Amp:
ioText {74, 37} {70, 24} display 0.000000 0.00100 "amp" left "Lucida Grande" 8 {0, 0, 0} {65280, 65280, 65280} background noborder 0.4184
ioText {35, 67} {41, 24} label 0.000000 0.00100 "" left "Lucida Grande" 8 {0, 0, 0} {65280, 65280, 65280} background noborder Freq:
ioText {75, 67} {69, 24} display 0.000000 0.00100 "freq" left "Lucida Grande" 8 {0, 0, 0} {65280, 65280, 65280} background noborder 427.6151
ioText {152, 34} {119, 69} label 0.000000 0.00100 "" left "Lucida Grande" 8 {0, 0, 0} {65280, 65280, 65280} nobackground border 
ioText {169, 72} {78, 24} display 0.000000 0.00100 "freqsweep" center "DejaVu Sans" 8 {0, 0, 0} {14080, 31232, 29696} background border 999.6769
ioButton {160, 37} {100, 30} event 1.000000 "Button 1" "Sweep" "/" i1 0 10
</MacGUI>

