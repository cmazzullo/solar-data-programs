function bright_select, int, n, box_size
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
  print, 'Left click to select points, right click to end'
  !mouse.button = 0
  find_brightest = 0
  while !mouse.button ne 4 do begin
     exptv, sigrange(int1)
     tvpos, x1, y1, wait=4

     if !mouse.button eq 1 then begin
        if ((x1 le nx) and (x1 ge 0) and (y1 le ny) and (y1 ge 0)) then begin
           if find_brightest then begin
              x1 = round(x1)
              y1 = round(y1)
              l = box_size
              window = int1[(x1-l):(x1+l), (y1-l):(y1+l)]
              point = mymax(window)
              px = x1 + point[0] - l
              py = y1 + point[1] - l
              x = [x, px]
              y = [y, py]
              n = n+1
              int1(px-1:px+1, py-1:py+1) = 0
           endif else begin
              x = [x, round(x1)]
              y = [y, round(y1)]
              n = n+1
              int1(x1-1:x1+1, y1-1:y1+1) = 0
           endelse
        endif
     endif

     if !mouse.button eq 2 then find_brightest = not (find_brightest)

  endwhile
  exptv, sigrange(int1)
  x=x[1:n_elements(x)-1]
  y=y[1:n_elements(y)-1]
  array = fltarr(2, n)
  array(0, *) = x
  array(1, *) = y
  return, array (*,*)
end
