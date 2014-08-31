; put more stuff in parameters, make more general
; need to add abswvl stuff
function window_velocity, infile = afile ; level one file

  ;; Creates lit_wvls from an init file
  fname = 'init.txt'
  init_data = read_init_file(fname)
  print, 'reading init data'
  print, 'file1 = ', file1

  ;; If filename was set, override init file
  if keyword_set(afile) then begin
     file1 = afile
  endif
  
  wvls = [180, 185, 192, 195, 197, 276, 280, 284]
  windowNs = [0, 3, 6, 8, 9, 21, 23, 24] ; wavelen windows to look at

  ;; abswl gives the wavelength of a part of the quiet sun
  ;; we need to subtract literature wavelength, then add shift for
  ;; velocity given by art and chae paper

  data = eis_getwindata(file1, 8, /refill, /quiet)
  points = tv_select(data.int, npts)
  
  ;column for wavelens, row for velocities  
  output = dblarr(n_elements(wvls) + 2, npts) 

  ;; j is the current window number
  for j = 0, (n_elements(windowNs) - 1) do begin
     windowN = windowNs[j]      ;which data window to view
     data = eis_getwindata(file1, windowN, /refill)
     newdata = dblarr(3, npts)

     ;; i is the current point
     for i = 0, npts - 1 do begin
        x = points[0, i]
        y0 = points[1, i]

        ; Compensates for changes in y caused by tilted CCD
        y = yshiftap(wvls[j], wvls[3], y0)

        fitvel = vel_at_point(x, y, data, windowN, init_data.lit_wvls)

        ;; output[j, 0] and [j, 1] store the x and y coordinates
        ;; the velocities are stored in the rest of the array
        output[0, i] = x
        output[1, i] = y
        output[j + 2, i] = fitvel
     endfor
  endfor

  print, wvls
  print, output
  return, output
  
end
