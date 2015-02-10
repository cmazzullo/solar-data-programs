pro plot_velocity, windowN, vel_output, output
  @init
  cube = vel_output.cube
  points = new_select(cube, windowN, n)
  output = process_points(windowN, points, cube)
  plot, output[*, 0, 1], yrange=[-30, 30]
  for i = 1, n_elements(output[0, *, 0]) - 1 do begin
     color = i*32-1
     oplot, output[*, i, 1], color=color, psym=-i, line=i

     wname = vel_output.window_names[i] 
     fname = strtrim(windowNs[i], 1) + '-' + wname
;     fname = STRJOIN(STRSPLIT(fname, /EXTRACT), '_')
     print, fname

     xyouts, 0, 30 - i*5, fname, color=color, font=0
  endfor
end
