function quick_dataset
  xdim = 100
  ydim = 200
  arr = fltarr(xdim, ydim)
  xscale = 0.1
  yscale = 0.1
  for i=0,xdim-1 do begin
     for j=0,ydim-1 do begin
        arr[i, j] = cos(xscale*i) + cos(yscale*j)
     endfor
  endfor
  return, arr
end