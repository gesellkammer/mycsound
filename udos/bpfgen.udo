opcode bpfgen,i[],i[]i
/*
Create and evaluate a break-point function with linear interpolation

* ipairs: an array of the form [x1, y1, x2, y2, ..., xn, yn]
* iprecision: the number of decimal points to sample the x coord

Example
=======

    ipairs[] array -3, 4, 0, 1, 3.04, 10, 52.4, 0
    ibpf bpfgen ipairs, 2

    ; Use bpfat to evaluate the function (at any rate)
    ky bpfat ibpf, kx
    ay bpfat ibpf, ax  

*/
  ipairs[], iprecision xin
  ipairslen = lenarray(ipairs)
  ix0 = ipairs[0]
  ix1 = ipairs[ipairslen-2]
  imul = 10^iprecision
  ; this is twice the smallest x resolution
  ieps = 1/imul*2
  irange = (ix1 + ieps) - ix0
  ilen = imul * irange
  idelta = ix0 * -1
  iargs[] init ipairslen+2
  idx = 0
	
  while idx < ipairslen do
    iargs[idx] = (idx % 2 == 0) ? int((ipairs[idx] + idelta) * imul) : ipairs[idx]
    idx += 1
  od

  ; we append an extra point to keep the slope outside the range
  ; otherwise tablei will interpolate with the start point.
  iargs[ipairslen] = iargs[ipairslen-2] + ieps
  iargs[ipairslen+1] = iargs[ipairslen-1]
	
  itab ftgen 0, 0, -(ilen+1), -27, iargs
	
  iout[] array itab, ilen, imul, idelta
  xout iout  
endop

opcode bpfat,k,i[]k
  ; evalueate a bpf created with bpfgen
  ipairsdata[], kx xin
  itab = ipairsdata[0]
  imul = ipairsdata[2]
  idelta = ipairsdata[3]
  xout tablei:k((kx + idelta) * imul, itab)
endop

opcode bpfat,a,i[]a
  ; evaluate a bpf created with bpfgen
  ipairsdata[], ax xin
  itab = ipairsdata[0]
  imul = ipairsdata[2]
  idelta = ipairsdata[3]
  xout tablei:a((ax + idelta) * imul, itab)
endop