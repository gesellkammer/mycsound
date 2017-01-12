# Miscelaneous ugens for csound

## bpf

Breakpoint function (linear interpolation)

Interpolates between the points (kxn, kyn)



    ky  bpf kx, kx0, ky0, kx1, ky1, kx2, ky2, ...


## linlin

Linear to linear conversion, similar to Supercollider's `linlin`.

Converts a value `x` defined within a range `kxlow - kxhigh` to the range
`kylow - kyhigh`


    ky  linlin kx, kxlow, kxhigh, kylow, kyhigh


## ftom, mtof

Frequency <--> Midi conversion with optional value for A4
(default=442)


    kfreq = mtof(69, 443)  ; the reference freq. is optional


## ntom, mton

Notename to midi conversion. Format used: `4C[+15]`

* Octave + notename. `4C`, `5Db`, `3A#`, etc
* `4C` is the central C on the piano
* Cents can be indicated as `4C+15` (15 cents higher), `4C-31` (31
cents lower)
* `4C+` is also accepted, and is the same as `4C+50` (the same is
valid for `4C-`
* Only uppercase is accepted


