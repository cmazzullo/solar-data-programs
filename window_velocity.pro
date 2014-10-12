function window_velocity, data_windows ; big struct made by all_window_data
  ;; Creates lit_wvls from an init file
  fname = 'init.txt'
  init_data = read_init_file(fname)
  print, 'Reading init data...'

  wvls = init_data.wvls
  windowNs = init_data.windowNs
  lit_wvls = init_data.lit_wvls
  vel_corr = init_data.vel_corr
  box_size = init_data.box_size
  estimates = init_data.estimates

  ;; abswl gives the wavelength of a part of the quiet sun
  ;; we need to subtract literature wavelength, then add shift for
  ;; velocity given by art and chae paper
  ;; to get absolute wl: abswl=wl-offset(i,j)-abs 
  abswl_window = 3              ; use Fe VIII (window 3)
  
  print, '------------------------------------------------------------'
  print, 'INSTRUCTIONS:'
  print, 'Using Fe VIII (window ', abswl_window, ') to get absolute wavelength shift'
  print, 'Left click on the lower left and upper right corner to select a box'
  print, 'Select a box around an area of quiet sun'
  print, '------------------------------------------------------------'

  wdfe8 = get_window(data_windows, abswl_window)
  wlcorr = wdfe8.wave_corr
  ;params = 0
  abswl, wdfe8, mx, my, wlcorr, params
  abswl_shift = lit_wvls[abswl_window] - params(1)
  print, 'abswl shift = ', abswl_shift
  
  data = get_window(data_windows, 8)
  print, 'Displaying Fe XII (window 8)'
  print, '------------------------------------------------------------'
  print, 'INSTRUCTIONS:'
  print, 'Select points with left click, then confirm your selections'
  print, ' with a right click'
  print, '------------------------------------------------------------'

  points = bright_select(data.int, npts, box_size)
  
  ; column for wavelens, row for velocities  
  output = dblarr(npts, n_elements(wvls), 4) 

  ;; j is the current window number
  for j = 0, (n_elements(windowNs) - 1) do begin
     windowN = windowNs[j]      ;which data window to view
     data = get_window(data_windows, windowN)
     newdata = dblarr(3, npts)

     ;; i is the current point
     for i = 0, npts - 1 do begin
        x = points[0, i]
        y0 = points[1, i]

        ; Compensates for changes in y caused by tilted CCD
        y = yshiftap(wvls[j], wvls[3], y0)

        ;; output is a cube
        ;; point # is the x axis
        ;; window # is the y axis
        ;; x, y and velocity are stored up the z axis (like a stack)
        output[i, j, 0] = x
        output[i, j, 1] = y
        index = where(estimates[0, *] eq windowNs[j], count)
        if count eq 0 then begin
           fitvel = vel_at_point(x, y, data, windowN, lit_wvls, $
                                 abswl_shift, vel_corr)
           output[i, j, 2] = fitvel
           output[i, j, 3] = !values.f_nan ; this spot is reserved for windows with >1 lines
        endif else begin
           for k = 0, n_elements(index) - 1 do begin
              est_arr = estimates[*, index[k]]
              fitvel = vel_at_point(x, y, data, windowN, 0, $
                                    abswl_shift, vel_corr, estimates=est_arr)
              output[i, j, 2 + k] = fitvel
           endfor
        endelse
     endfor
  endfor
  print, '------------------------------------------------------------'
  print, 'OUTPUT FORMAT:'
  print, 'Output format is a 3-dimensional array:'
  print, '[point #, line #, [x, y, velocity (, ..., velocityN)]]'
  print, '------------------------------------------------------------'
  return, output
end
