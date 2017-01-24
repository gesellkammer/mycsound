opcode bufnew,i,io
  ; create an empty table capable of holding a sound of the given duration
  idur, itableidx xin
  idx = ftgen(itableidx, 0, idur*sr, -2, 0)
  xout idx
endop

opcode bufrec,k,ak
  /* record asig to kbuf continuously. If at the end of buf, stop recording, kpos = 0
  ; otherwise, kpos indicates the pointer after having writen to the buf, so
  ; it is always a positive number. You should catch this situation or
  ; writing will resume at the beginning of the table at the next k-pass
  ; a simple way of playing back is:
  
     kpos init 0
     asig tablera ktab, kpos, 0
	 kpos += ksmps

  Or, otherwise, use a phasor with table, tablei, table3, or flooper2 for looping, etc.
  
  */ 
  asig, kbuf xin

  kpos init 0
  klastbuf init -1

  if kbuf != klastbuf then
    kpos = 0
	klastbuf = kbuf
  endif
  
  kpos tablewa kbuf, asig, kpos
  xout kpos
endop

