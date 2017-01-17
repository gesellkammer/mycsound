<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=null -M0 -Q0
</CsOptions>
<CsInstruments>


	sr = 44100  
	ksmps = 32
	nchnls = 2	
	0dbfs = 1

	gifftsize 	= 1024
	giAmps		ftgen	0, 0, gifftsize/2, 2, 0
	giFreqs		ftgen	0, 0, gifftsize/2, 2, 0
	giActiveEvents	ftgen	0, 0, 128, 2, 0
	giTempEvents	ftgen	0, 0, 128, 2, 0
	giZeroEvents	ftgen	0, 0, 128, 2, 0

;*********************************************************************
; analyze pvs
; write to tables
; zero temp_events
; iterate over tables freq/amp in sync
; if amp > thresh
; if minfreq<freq<maxfreq
; freq to midi note 
; add note to temp_events
; if note not in active_events
; generate event[note,vel] and add to active_events

; iterate over active_events
; if event not in temp_events
; stop event and remove from active_events


; TODO
; retrig note when amplitude changes more than e.g. 3 dB
; retrig both when louder and quieter
; input control for number of amplitude levels (dBchange = max_amp_range / numLevels)

;*********************************************************************
	instr	1
	a1,a2	ins
		chnset a1, "audioIn"
	endin

	instr	2
	kampThresh	= 0.03
	klowNote	= 12
	khighNote	= 94	
			chnset kampThresh, "ampThresh"
			chnset klowNote, "lowNote"
			chnset khighNote, "highNote"
	endin

;*********************************************************************
	instr	9

	a1		chnget "audioIn"
	a0		= 0
			chnset a0, "audioIn"

	kampThresh	chnget "ampThresh"
	klowNote	chnget "lowNote"
	khighNote	chnget "highNote"
	knote		init 0
	ioverlap  	= gifftsize / 4
	iwinsize  	= gifftsize
	iwinshape 	= 1
	f1     		pvsanal a1, gifftsize, ioverlap, iwinsize, iwinshape
	kflag		pvsftw	f1, giAmps, giFreqs
	if kflag > 0 then
			tablecopy giTempEvents, giZeroEvents
	kindx		= 0
readspectral:
	kamp		table kindx, giAmps
	kfreq		table kindx, giFreqs
	if kamp > kampThresh then
	  knote		= round(12 * (log(kfreq/220)/log(2)) + 57)
	  if knote > klowNote then
	  if knote < khighNote then
	  		tablew knote, knote, giTempEvents			; add note to temp events
	    ktest	table knote, giActiveEvents
	    if ktest == 0 then							; if it is not already playing
	      kvelocity	= 10^(dbfsamp(kamp)/40) * 127 
	      ichannel	= 1
	      kinstNum	= 201 + (knote*0.001)
	      event	"i", kinstNum, 0, -1, kvelocity, knote, ichannel	; turn on midi note
	  		tablew knote, knote, giActiveEvents			; and add note to active events
	    endif
	  endif
	  endif
	endif
	kindx		= kindx	+ 1
	if kindx < gifftsize goto readspectral
	kindx2		= 0
readnotes:									; check all active events, turn off as appropriate
	kactive		table kindx2, giActiveEvents
	ktemp		table kindx2, giTempEvents
	if (kactive > 0) && (ktemp = 0) then					; if it is active and currently not having enough enery in the frequency band (note)
	      kinstNum	= 201 + (kactive*0.001)
	      event	"i", -kinstNum, 0, .1, 0, kactive, 0			; turn off midi note
			tablew 0, kindx2, giActiveEvents				; remove note from active events
	endif
	kindx2		= kindx2	+ 1
	if kindx2 < 128 goto readnotes
	endif
	endin

;***************************************************
; midi out instrument
;***************************************************
	instr	201

; midi file out 
; (set name for midi outfile on commandline e.g. --midioutfile=test.mid)

	idur		= (p3 < 0 ? 999 : p3)	; use very long duration for realtime events, noteondur will create note off when instrument stops
	ivel		= p4
	inum		= p5
	ichn		= p6
			noteondur ichn, inum, ivel, idur
	endin
;***************************************************
</CsInstruments>
<CsScore>
i1 0 86400
i2 0 1
i9 0 86400
e
</CsScore>
</CsoundSynthesizer>
