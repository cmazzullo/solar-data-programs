pro plot_correlations, vel_output
  @init
  cube = vel_output.cube

  for i=0,n_elements(windowNs)-1 do begin
     n = windowNs[i]
     win = reform(cube[i, *, *, *])
     int = reform(win[0, *, *])
     wvl = reform(win[1, *, *])

     c = 3e5
     lit_wvl = lit_wvls[n]
     vel = c * (lit_wvl - wvl) / lit_wvl

     ;; Data cleaning
     vel[where(abs(vel) gt 50)] = 0
     int[where(vel eq 0)] = 0


     sorted = sort(int)
     n_ignored = 50
     cutoff_index = sorted[n_elements(sorted)-n_ignored-1]
     cutoff = int[cutoff_index]

     plot, vel, int, yrange=[0, cutoff], subtitle='Velocity and intensity in Fe XI', font=0, xtitle='Velocity (km/s)', ytitle='Intensity', psym=3
     wname = vel_output.window_names[i] 
     ;; print, wname, correlate(int, vel)
     
     fname = strtrim(windowNs[i], 1) + '-' + wname + '.png'
     fname = STRJOIN(STRSPLIT(fname, /EXTRACT), '_')
     write_png, 'pics/' + fname, tvrd(/true)
     ;;wait, 2
  endfor
end
