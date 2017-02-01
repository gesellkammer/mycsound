opcode bufnew,i,io
  ; create an empty table capable of holding a sound of the given duration
  idur, itableidx xin
  ; negative size allowes for non-power of 2 sizes.
  ; Don't know if this is really needed
  idx = ftgen(itableidx, 0, -(idur*sr), -2, 0)
  xout idx
endop

opcode bufrec,k,ak
  /*
  Record asig to kbuf continuously. If the end of the buffer is reached,
  recording is stopped and kpos = 0. Otherwise, kpos indicates the number
  of samples recorded.

  # Input Args

  asig: input signal
  kbuf: table number. If changed, recording is started from pos. 0 in the buffer

  # Output

  kpos: position in buffer after last rec.

  A simple way of playing back is:
  
     kpos init 0
     asig tablera ktab, kpos, 0
	 kpos += ksmps

  Otherwise, use a phasor with table, tablei, table3, or flooper2 for looping, etc.
  */ 
  asig, kbuf xin

  kpos init 0
  klastbuf init -1

  if kbuf != klastbuf then
    kpos = 0
	klastbuf = kbuf
  endif

  kmaxpos = tablen(kbuf)
  if kpos + ksmps < kmaxpos then
    kpos tablewa kbuf, asig, kpos
  else
    kpos = 0
  endif
  xout kpos
endop