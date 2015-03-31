pro select_points_to_plot, win1, win2, vel_output, points
  @init
  cube = vel_output.cube
  loadct, 3
  points = two_windows(cube, win1, win2, n)
  print, 'n = ', n
  print, points
  dim = size(cube)
  xdim = dim[3]
  ydim = dim[4]
  x = 0
  y = 0
  n1 = 0
  ;; add points in a square around selected points
  for k=0,n-1 do begin
     for i=-1,1 do begin
        for j=-1,1 do begin
           x1 = points[0, k] + i
           y1 = points[1, k] + j
           if ((x1 le 2*xdim) and (x1 ge 0) and (y1 le ydim) and (y1 ge 0)) then begin
              x = [x, x1]
              y = [y, y1]
              n1 = n1+1
           endif
        endfor
     endfor
  endfor

  print, 'n1 = ', n1
  points = intarr(2, n1)
  points[0, *] = x[1:n1]
  points[1, *] = y[1:n1]
  n = n1
end
