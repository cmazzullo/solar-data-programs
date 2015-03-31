;; ARGUMENTS

;; output: the output of select_points_to_plot.pro
;; points: the point output of select_points_to_plot.pro

pro plot_selected_points, win1, vel_output, points, windows_to_plot
  @init
  cube = vel_output.cube
  data = process_points(win1, points, cube)
  vels = data[*, *, 1]
  vels[where(abs(vels) gt 50)] = 0
  data[*, *, 1] = vels
  print, 'data = ', vels

  n = n_elements(points[0, *])
  loadct, 12
  y = intarr(n)
  wl0 = lit_wvls[windowNs[win1]]
  print, 'points: ', points
  x = points[0, *]
  print, 'x: ', x
  d = dblarr(n)
  clusters = n / 9
  
  for i = 0, n_elements(windows_to_plot) - 1 do begin
     wl = lit_wvls(windowNs[windows_to_plot[i]])
     for j = 0, n - 1 do begin
        y[j] = round(yshiftap(wl, wl0, points[1, j]))
     endfor
     print, 'shifted_y: ', y

     tot = 0
     for j = 1, clusters - 1 do begin
        i1 = 9*j + 4
        i0 = 9*(j - 1) + 4
        tot += sqrt((x[i1] - x[i0])^2 + (y[i1] - y[i0])^2)
        d[j*9:(j+1)*9-1] = tot
     endfor
     print, 'd = '
     print, d
     color = i*32-1
     if i eq 0 then begin 
        plot, d, data[*, 0, 1], yrange=[-30, 30], color=-1, psym=0, line=0
     endif else begin
        oplot, d, data[*, i, 1], color=color, psym=i, line=i
     endelse

     wname = vel_output.window_names[windows_to_plot[i]] 
     line_name = strtrim(windowNs[windows_to_plot[i]], 1) + '-' + wname
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
