;; Grabs a window by number out of the struct
function get_window, struct, index
  tag = 'window_' + strtrim(string(index), 1)
  void = execute('window = struct.' + tag)
  return, window
end

function mymax, window
  val = max(window, index)
  winsize = size(window)
  l = winsize[1]
  x = index mod l
  y = index / l
  return, [x, y]
end

; INPUT:
;   X, Y: the point to consider
;   DATA: the data window returned from eis_getwindata
;   ABSWL_SHIFT: the wavelength shift to add to the data as returned
;   from abswl.pro
;   ESTIMATES: for windows with more than one line, it may be
;   necessary to supply mpfitpeak with initial guesses
;
; OUTPUT:
;   An array containing the wavelength of the line and the sigma of
;   the fit (the width of the line). Format: [fitvel, sigma]

function wvl_at_point, x, y, data, abswl_shift, estimates=est

  ;; If estimates are given, use them in the fit.
  if keyword_set(est) then begin
     fit = mpfitpeak(data.wvl, data.int[*, x, y], output, nterms=4, $
                     error=data.err[*, x, y], estimates=est[1:*], perror=perror)
  endif else begin
     fit = mpfitpeak(data.wvl, data.int[*, x, y], output, nterms=4, $
                     error=data.err[*, x, y], perror=perror)
  endelse

  wvl_error = perror[1]
  wvl = output[1]               ; Centroid of the Gaussian

  ; then use wave_corr to correct for orbital variations
  ; and add the absolute wavelength shift and manual correction
  wvl = wvl - data.wave_corr[x, y] + abswl_shift
  return, [wvl, wvl_error]

end

;; This function returns the velocity moving *towards you*

;; X and Y are the coordinates that we're looking at
;; DATA is the struct containing all of the intensity data and such
;; WINDOWN is the Window Number of the data set we're considering
;; LIT_WVLS is an array containing the wavelengths according to
;; the literature

function vel_at_point, x, y, data, windown, lit_wvls, abswl_shift, estimates=est

  if keyword_set(est) then begin
     wvl_arr = wvl_at_point(x, y, data, abswl_shift, estimates=est)
     lit_wvl = est[2]
  endif else begin
     wvl_arr = wvl_at_point(x, y, data, abswl_shift)
     lit_wvl = lit_wvls[windowN]
  endelse

  wvl = wvl_arr[0]
  wvl_error = wvl_arr[1]
  c = 3.0 * 10.0^5                  ; Speed of light in km/s
  vel_error = (wvl_error * c) / lit_wvl
  delwvl = lit_wvl - wvl
  v = c * delwvl / lit_wvl
  return, [v, vel_error]

end

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
     plot_image, sigrange(int1)
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
  plot_image, sigrange(int1)
  x=x[1:n_elements(x)-1]
  y=y[1:n_elements(y)-1]
  array = fltarr(2, n)
  array(0, *) = x
  array(1, *) = y
  return, array (*,*)
end


function window_velocity, data_windows ; big struct made by all_window_data
  ;; Creates lit_wvls from an init file
  fname = '/swd4/Users/EIS/cmazzullo/solar-data-programs/init.txt'
  @init
  info = eis_get_wininfo(file)
  nwin = n_elements(windowNs)
  wvls = dblarr(nwin)
  window_ids = dblarr(nwin)
  for i=0, nwin-1 do begin
     win = windowNs[i]
     wvls[i] = info[win].wvl_min
     window_ids[i] = info[win].line_id
  endfor

  loadct, 3                     ; red temperature color table - very important!

  ;; abswl gives the wavelength of a part of the quiet sun
  ;; we need to subtract literature wavelength, then add shift for
  ;; velocity given by art and chae paper
  ;; to get absolute wl: abswl=wl-offset(i,j)-abs

  print, '------------------------------------------------------------'
  print, 'INSTRUCTIONS:'
  print, 'Using Fe VIII (window ', abswl_window, ') to get absolute wavelength shift'
  print, 'Left click on the lower left and upper right corner to select a box'
  print, 'Select a box around an area of quiet sun'
  print, '------------------------------------------------------------'

  abswl_data = get_window(data_windows, abswl_window)
  abswl, abswl_data, mx, my, abswl_data.wave_corr, params

  abswl_shift = lit_wvls[abswl_window] - params[1]
  print, 'abswl shift = ', abswl_shift

  data = get_window(data_windows, display_window)
  print, 'Displaying', window_ids[display_window] 
  print, '------------------------------------------------------------'
  print, 'INSTRUCTIONS:'
  print, 'Select points with left click, then confirm your selections'
  print, ' with a right click'
  print, '------------------------------------------------------------'

  points = bright_select(data.int, npts, box_size)
  output = dblarr(npts, n_elements(wvls), 5)

  ;; j is the current window number
  for j = 0, nwin-1 do begin
     windowN = windowNs[j]      ;which data window to view
     data = get_window(data_windows, windowN)
     newdata = dblarr(3, npts)

     ;; i is the current point
     for i = 0, npts - 1 do begin
        x = points[0, i]
        y0 = points[1, i]

        ;; Compensates for changes in y caused by tilted CCD
        y = yshiftap(wvls[j], wvls[3], y0)

        ;; output is a cube
        ;; point # is the x axis
        ;; window # is the y axis
        ;; x, y, uncertainty and velocity are stored up the z axis (like a stack)
        output[i, j, 0] = x
        output[i, j, 1] = y
        index = where(estimates[0, *] eq windowNs[j], count)
        if count eq 0 then begin
           vel_arr = vel_at_point(x, y, data, windowN, lit_wvls, $
                                  abswl_shift)
           fitvel = vel_arr[0]
           sigma = vel_arr[1]
           output[i, j, 2] = sigma
           output[i, j, 3] = fitvel
           output[i, j, 4] = !values.f_nan ; this spot is reserved for windows with >1 lines
        endif else begin
           for k = 0, n_elements(index) - 1 do begin
              est_arr = estimates[*, index[k]]
              vel_arr = vel_at_point(x, y, data, windowN, 0, $
                                     abswl_shift, estimates=est_arr)
              fitvel = vel_arr[0]
              sigma = vel_arr[1]
              output[i, j, 2] = sigma
              output[i, j, 3 + k] = fitvel
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
