function process_points, line_number, points, cube
;; First we need to get the yshift of all the points
@init
  wl0 = lit_wvls[windowNs[line_number]] ; wavelength of the line that we plotted
  n_points = n_elements(points) / 2
  shifted_points = dblarr(2, n_points)
  shifted_points[0, *] = points[0, *] ; copy over the x values
  dims = size(cube)
  n_wins = dims[1]
  n_types = dims[2]
  n_x = dims[3]
  n_y = dims[4]

  output = dblarr(n_points, n_wins, n_types)
  for i = 0, n_points - 1 do begin ; go through all the points
     for j = 0, n_wins - 1 do begin ; go through all the windows
        wl = lit_wvls[windowNs[j]]
        x = points[0, i]
        shifted_y = round(yshiftap(wl, wl0, points[1, i]))
        print, shifted_y
        shifted_points[1, i] = shifted_y
        output[i, j, *] = cube[j, *, x, shifted_y]
	output[i, j, 1] = 3e5*(output[i, j, 1] - wl)/wl
     endfor
     ; print, 'Shifted y values for point', i, ':', shifted_points
  endfor

  return, output ; [point, window, data_type]
end
