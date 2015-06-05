;; This script takes a level one file all the way through.  It gets
;; all window data, does a gaussian fit on every point and stores
;; everything in a big data cube for every window in the data set.

;; Output format is [windowNumber, (fit.aa + fit.sigmaa), x, y]
;; Fit params: [intensity, centroid, line width]
;; Right now this assumes 1 line per window!!!

function fit_to_velocity, fit_window, lit_wvl, abswl_shift
  fit_params = fit_window.aa
  err_params = fit_window.sigmaa
  wvls = fit_params[1, *, *]
  wvl_err = err_params[1, *, *]
  abs_wvls = wvls + abswl_shift ; this assumes that wave_corr was already applied by Young's program!
  c = 3*10.0^5
  vels = c * (lit_wvl - abs_wvls) / lit_wvl
  vel_err = c * wvl_err / lit_wvl
  new_window = add_tag(fit_window, vels, 'velocity')
  new_window = add_tag(new_window, vel_err, 'velocity_err')
  return, new_window
end

function get_all_velocity

  @init
  N = n_elements(windowNs)
  window_names = strarr(N)

  data = eis_getwindata(file, windowNs[0], /refill, /quiet)
  nx = data.nx
  ny = data.ny

  cube = dblarr(N, 6, nx, ny)

  data_struct = create_struct( 'filename',        file,   $
                               'window_numbers',  windowNs )  

  loadct, 3                     ; red temperature color table - very important!
  abswl_data = eis_getwindata(file, abswl_window, /refill, /quiet)
  abswl, abswl_data, mx, my, abswl_data.wave_corr, params
  abswl_shift = lit_wvls[abswl_window] - params[1]
  wdelete ; deletes current window - makes screen work

  for j = 0, N-1 do begin
     windowN = windowNs[j]      ;which data window to view
     lit_wvl = lit_wvls[windowN]
     data = eis_getwindata(file, windowN, /refill, /quiet)
     winstr = strtrim(string(windowN), 1)
     ;; data_struct = create_struct(data_struct, 'window_' + winstr, data)

     eis_auto_fit, data, fit, offset=data.wave_corr
     fit = fit_to_velocity(fit, lit_wvl, abswl_shift)
     data_struct = create_struct(data_struct, 'fit_window_' + winstr, fit)

     cube[j, 0:2, *, *] = fit.aa[0:2, *, *]
     cube[j, 3:5, *, *] = fit.sigmaa[0:2, *, *]
     window_names[j] = data.line_id
  endfor

  data_struct = create_struct( data_struct, $
                               'window_names',    window_names,  $
                               'cube',            cube )
  return, data_struct

end
