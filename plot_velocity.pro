;; This is the basic template for v_along_loop
;; You should probably use v_along_loop instead

;; This program displays an intensity picture of the sun at a certain
;; wavelength and allows the user to select points along a loop. The
;; velocity at those points is then plotted as a function of distance
;; along the loop.

;; ARGUMENTS
;; - INPUTS

;; windowN: the wavelength window of the intensity picture

;; vel_output: the output of get_all_velocity.pro, a struct containing
;; velocity data

;;  - OUTPUTS

;; output: the fit parameters and velocity at the selected points, as
;; output by process_points.pro. The format is: 
;; [point, window, param] where the params are peak height, velocity, line width,
;; height error, velocity error and width error.

;; points: the x-y points selected by the user in the window that they used


pro plot_velocity, windowN, vel_output, output, points, run_number=run_number
  @init
  cube = vel_output.cube
  loadct, 3
  points = new_select(cube, windowN, n)

  if keyword_set(run_number) then begin
     filename = 'run_' + strtrim(string(run_number), 1) + '-points.png'
     write_png, filename, tvrd(/true)
  endif

  output = process_points(windowN, points, cube)
  loadct, 12
  vels = output[*, *, 1]
  vels[where(abs(vels) gt 50)] = 0
  output[*, *, 1] = vels
  for i = 0, n_elements(output[0, *, 0]) - 1 do begin
     color = i*32-1
     if i eq 0 then begin 
	plot, output[*, 0, 1], yrange=[-30, 30], color=1, psym=0, line=0
     endif else begin
        oplot, output[*, i, 1], color=color, psym=-i, line=i
     endelse

     wname = vel_output.window_names[i] 
     line_name = strtrim(windowNs[i], 1) + '-' + wname
     print, line_name
     fname = STRJOIN(STRSPLIT(line_name, /EXTRACT), '_')
     xyouts, 0, 40 - i*3, fname, color=color, font=0
  endfor

  if keyword_set(run_number) then begin
     filename = 'run_' + strtrim(string(run_number), 1) + '-results.png'
     write_png, filename, tvrd(/true)
  endif

  loadct, 3
end
