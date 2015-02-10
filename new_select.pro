function new_select, cube, line_number, n
  ;; cube is a 4-d data cube that comes out of get_all_velocity
  win = reform(cube[line_number, *, *, *])
  int = reform(win[0, *, *])
  dimen=size(int)
  nx=dimen(1)
  ny=dimen(2)
  x = 0
  y = 0
  n = 0
  print,'Left click to select points, right click to end'
  !mouse.button=0
  while !mouse.button ne 4 do begin
     ; window, 0, xpos=0, ypos=0, xsize=512, ysize=1024
     exptv, sigrange(int)
     tvpos, x1, y1
     wait, 0.5
     if (!mouse.button eq 1) then begin
        if ((x1 le nx) and (x1 ge 0) and (y1 le ny) and (y1 ge 0)) then begin
;the next statements add the new elements to the array
           x = [x, round(x1)]
           y = [y, round(y1)]
           n = n+1
; this makes black dots on image where points were measured
           int(x1-1:x1+1, y1-1:y1+1) = 0
        endif
     endif
  endwhile
  exptv, sigrange(int)
  x=x[1:n_elements(x)-1]
  y=y[1:n_elements(y)-1]
  array = fltarr(2, n)
  array(0, *) = x 
  array(1, *) = y
  return, array (*,*)
end
