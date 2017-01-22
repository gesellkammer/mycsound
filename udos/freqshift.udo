
opcode freqshift, a, ak
       ain, kfreq xin

       ; Phase quadrature output derived from input signal.
       areal, aimag hilbert ain

       ; Quadrature oscillator.
       asin oscili 1, kfreq
       acos oscili 1, kfreq, -1, .25

       ; Use a trigonometric identity.
       amod1 = areal * acos
       amod2 = aimag * asin

       aupshift = (amod1 - amod2) ; * 0.7
       ; adownshift corresponds to the difference frequencies.
       ; adownshift = (amod1 + amod2) * 0.7

       ; Notice that the adding of the two together is
       ; identical to the output of ring modulation.

       xout aupshift
endop
