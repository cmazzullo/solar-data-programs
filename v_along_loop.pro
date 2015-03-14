pro v_along_loop, windowN, vel_output, output, points, run_number=run_number
  @init
  cube = vel_output.cube
  loadct, 3
  points = new_select(cube, windowN, n)
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
           if ((x1 le xdim) and (x1 ge 0) and (y1 le ydim) and (y1 ge 0)) then begin
              x = [x, x1]
              y = [y, y1]
              n1 = n1+1
           endif
        endfor
     endfor
  endfor
  points = intarr(2, n1)
  points[0, *] = x[1:n1]
  points[1, *] = y[1:n1]
  n = n1

  if keyword_set(run_number) then begin
     filename = 'run_' + strtrim(string(run_number), 1) + '-points.png'
     write_png, filename, tvrd(/true)
  endif

  output = process_points(windowN, points, cube)
  loadct, 12
  vels = output[*, *, 1]
  vels[where(abs(vels) gt 50)] = 0
  output[*, *, 1] = vels
  y = intarr(n)
  wl0 = lit_wvls[windowNs[windowN]]
  print, 'points: ', points
  x = points[0, *]
  print, 'x: ', x
  d = dblarr(n)
  for i = 0, n_elements(output[0, *, 0]) - 1 do begin
     wl = lit_wvls(windowNs[i])
     for j = 0, n - 1 do begin
        y[j] = round(yshiftap(wl, wl0, points[1, j]))
     endfor
     print, 'shifted_y: ', y

     d[0] = 0
     tot = 0
     for j = 1, n - 1 do begin
        tot += sqrt((x[j] - x[j-1])^2 + (y[j] - y[j-1])^2)
        d[j] = tot
     endfor
     print, 'd = '
     print, d
     color = i*32-1
     if i eq 0 then begin 
        plot, d, output[*, 0, 1], yrange=[-30, 30], color=1, psym=0, line=0
     endif else begin
        oplot, d, output[*, i, 1], color=color, psym=-i, line=i
     endelse

     wname = vel_output.window_names[i] 
     line_name = strtrim(windowNs[i], 1) + '-' + wname
     print, line_name
     fname = STRJOIN(STRSPLIT(line_name, /EXTRACT), '_')
     xyouts, 0, 40 - i*3, fname, color=color, font=0
     wait, .5
  endfor

  if keyword_set(run_number) then begin
     filename = 'run_' + strtrim(string(run_number), 1) + '-results.png'
     write_png, filename, tvrd(/true)
  endif

  loadct, 3
end
