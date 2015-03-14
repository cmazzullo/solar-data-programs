function two_windows, cube
  @init
  n_mg = 5 ;; MG VII in the cube
  n_fe = 1 ;; FE VIII 

  mg_wvl = lit_wvls[windowNs[n_mg]]
  fe_wvl = lit_wvls[windowNs[n_fe]]

  mg_int = reform(cube[n_mg, 0, *, *])
  fe_int = reform(cube[n_fe, 0, *, *])

  dimen = size(mg_int)
  xdim = dimen[1]
  ydim = dimen[2]

  both_int = [mg_int * 5, fe_int]
  both_int[ where( both_int ge 100000.0 ) ] = 0.0

  xpoints = 0
  ypoints = 0

  !mouse.button = 0
  while !mouse.button ne 4 do begin
     exptv, sigrange(both_int)
     tvpos, x, y
     wait, 0.5
     x = round(x)
     y = round(y)
     if (!mouse.button eq 1) then begin
        if ((x le 2*xdim) and (x ge 0) and (y le 2*ydim) and (y ge 0)) then begin
           frame = floor(x / xdim)
           other = (frame + 1) mod 2
           wvls = [mg_wvl, fe_wvl]
           wvl0 = wvls[frame]
           wvl = wvls[other]

           y_other = round(yshiftap(wvl, wvl0, y))
           print, wvl, wvl0, y, y_other
           x_other = other * xdim + (x mod xdim)
           both_int(x - 1 : x + 1, y - 1 : y + 1) = 100000
           both_int(x, y) = 0
           both_int(x_other - 1 : x_other + 1, y_other - 1 : y_other + 1) = 100000
           xpoints = [xpoints, round(x)]
           ypoints = [ypoints, round(y)]
        endif
     endif
  endwhile

  xpoints=xpoints[1:n_elements(xpoints)-1]
  ypoints=ypoints[1:n_elements(ypoints)-1]
  points = intarr(2, n_elements(xpoints))
  points[0, *] = xpoints
  points[1, *] = ypoints
  return, points

end
