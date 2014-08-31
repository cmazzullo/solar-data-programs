function tv_select, int, n
;int is the 3 d array of wl, x, y
;left click to select points, right click to end
;int is the intensity image
;nx and ny are the respective dimension of the image
;count is the number of points you want to select along the loop
;x and y are the position arrays along the loop
;set up a second array so we can zero out the points around the selected ;point so it shows up in the image.
  int1 =average( int,1)
  dimen=size(int1)
  nx=dimen(1)
  ny=dimen(2)
  x = 0
  y = 0
  n = 0
  print,'left click to select a point, right click to end'
  !mouse.button=0
  while !mouse.button ne 4 do begin
     exptv, sigrange(int1)
     tvpos, x1, y1
     wait, 0.5
     if (!mouse.button eq 1) then begin
        if ((x1 le nx) and (x1 ge 0) and (y1 le ny) and (y1 ge 0)) then begin
;the next statements add the new elements to the array
           x = [x, round(x1)]
           y = [y, round(y1)]
           n = n+1
; this makes black dots on image where points were measured
           int1(x1-1:x1+1, y1-1:y1+1) = 0
        endif
     endif
  endwhile
  exptv, sigrange(int1)
  x=x[1:n_elements(x)-1]
  y=y[1:n_elements(y)-1]
  array = fltarr(2, n)
  array(0, *) = x 
  array(1, *) = y
  return, array (*,*)
end
