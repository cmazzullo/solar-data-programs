pro pp_v, output

  dimen = size(output)
  n_points = dimen[1]
  n_wvls = dimen[2]
  n_z = dimen[3]

  for i=0, n_points - 1 do begin
     print, 'Point #:', i + 1
     print, 'x = ', output[i, 3, 0]
     for j=0, n_wvls-1 do begin
        print, 'y = ', output[i, j, 1], '  velocity = ', output[i, j, 3], '  error = ', output[i, j, 2]
     endfor
  endfor
;; velocity + error nextto it
;; different points at the same temp
;; or different temps for the same point

end
