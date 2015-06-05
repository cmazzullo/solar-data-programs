function scale_to_one, array
  max = max(array)
  return, array / max
end

function select_multiple, dws
  ;; construct the picture
  windowNs = dws.window_numbers
  win = get_window(dws, windowNs[0])
  nx = win.nx
  ny = win.ny
  N = n_elements(windowNs)
  allwindows = dblarr(N * nx, ny)
  for i=0, N - 1 do begin
    win = get_window(dws, windowNs[i])
    int = win.int
    intav = average(int, 1)
    scaled = scale_to_one(intav)
    allwindows[i*nx:(i+1)*nx-1, *] = scaled
  endfor

  x = 0
  y = 0
  m = 0
  print, 'Left click to select points, right click to end'
  !mouse.button = 0
  find_brightest = 0
  while !mouse.button ne 4 do begin
     plot_image, allwindows
     tvpos, x1, y1, wait=4

     if !mouse.button eq 1 then begin
        if ((x1 le n*nx) and (x1 ge 0) and (y1 le ny) and (y1 ge 0)) then begin
           if find_brightest then begin
              x1 = round(x1)
              y1 = round(y1)
              l = box_size
              window = allwindows[(x1-l):(x1+l), (y1-l):(y1+l)]
              point = mymax(window)
              px = x1 + point[0] - l
              py = y1 + point[1] - l
              x = [x, px]
              y = [y, py]
              m = m+1
              for k=0, N-1 do begin
                 tempx = px+k*nx
                 allwindows[tempx-1:tempx+1, y1-1:y1+1] = 0
              endfor
           endif else begin
              x = [x, round(x1) mod nx]
              y = [y, round(y1)]
              m = m+1
              for k=0, N-1 do begin
                 tempx = x1+k*nx
                 allwindows[tempx-1:tempx+1, y1-1:y1+1] = 0
              endfor
           endelse
        endif
     endif

     if !mouse.button eq 2 then find_brightest = not (find_brightest)
  endwhile

  exptv, sigrange(allwindows)
  print, 'x = ', x
  x=x[1:n_elements(x)-1]
  y=y[1:n_elements(y)-1]
  array = fltarr(2, m)
  array(0, *) = x
  array(1, *) = y
  return, array (*,*)
end
