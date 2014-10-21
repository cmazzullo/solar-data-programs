PRO VELOCITY_GRAPH, window

  wvls = [180, 185, 192, 195, 197, 276, 280, 284]
  windowNs = [0, 3, 6, 8, 9, 21, 23, 24] ;wavelen windows to look at

  data = eis_getwindata(file, 8, /refill, /quiet)
  points = tv_select(data.int, npts)
  marked_data = average(data.int, 1)

  for i = 0, (npts - 1) do begin
     marked_data[round(points[0, i]), round(points[1, i])] = 0
     marked_data[round(points[0, i]), round(points[1, i]) + 1] = 0
     marked_data[round(points[0, i]), round(points[1, i]) - 1] = 0
     marked_data[round(points[0, i] - 1), round(points[1, i] + 1)] = 0
     marked_data[round(points[0, i] - 1), round(points[1, i] - 1)] = 0
     marked_data[round(points[0, i] - 1), round(points[1, i])] = 0
     marked_data[round(points[0, i] + 1), round(points[1, i])] = 0
     marked_data[round(points[0, i] + 1), round(points[1, i] + 1)] = 0
     marked_data[round(points[0, i] + 1), round(points[1, i] - 1)] = 0
  endfor

;;  Write the marked data to a .png
  loadct, 10
  plot_image, marked_data
  tv, marked_data
  filename = './marked_data.png'
  write_png, filename, tvrd(/true)
  print, 'File written to ', filename

  ;; column for wavelens, row for velocities
  output = dblarr(n_elements(wvls), npts)

  for j = 0, (n_elements(windowNs) - 1) do begin

     windowN = windowNs[j]      ;which data window to view
     data = eis_getwindata(FILE, windowN, /refill)
     newdata = dblarr(3, npts)
     for i = 0, npts - 1 do begin
        x = points[0, i]
        y0 = points[1, i]

                                ; Compensates for changes in y caused by tilted CCD
        y = yshiftap(wvls[j], wvls[3], y0)
        print, y0, y

        fitvel = vel_at_point(x, y, data, windowN)
        output[j, i] = fitvel
     endfor
  endfor

  print, wvls
  print, output
END
