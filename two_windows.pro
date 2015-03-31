;; NOTE
;; This programs return points as if they were selected in the LEFT window!
;; INPUTS
;; cube: the data cube containing intensity and velocity 
;; win1: the window to display on the left
;; win2: the window to display on the right

;; OUTPUTS
;; n: the number of points selected

function two_windows, cube, win1, win2, n
  @init
  wvl1 = lit_wvls[windowNs[win1]]
  wvl2 = lit_wvls[windowNs[win2]]

  int1 = reform(cube[win1, 0, *, *])
  int2 = reform(cube[win2, 0, *, *])

  dimen = size(int1)
  xdim = dimen[1]
  ydim = dimen[2]

  both_int = [sigrange(int1), sigrange(int2)]
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

     xs = intarr(2)
     ys = intarr(2)

     if (!mouse.button eq 1) then begin
        if ((x le 2*xdim) and (x ge 0) and (y le ydim) and (y ge 0)) then begin
           frame = floor(x / xdim)
           other = (frame + 1) mod 2
           wvls = [wvl1, wvl2]
           wvl0 = wvls[frame]
           wvl = wvls[other]
           x_other = other * xdim + (x mod xdim)
           y_other = round(yshift2(wvl, wvl0, y))
           xs[other] = x_other
           xs[frame] = x
           ys[other] = y_other
           ys[frame] = x

           xpoints = [xpoints, round(xs[0])]
           ypoints = [ypoints, round(ys[0])]

           both_int(x - 1 : x + 1, y - 1 : y + 1) = 0.0
           both_int(x_other - 1 : x_other + 1, y_other - 1 : y_other + 1) = 0.0
        endif
     endif
  endwhile

  xpoints=xpoints[1:n_elements(xpoints)-1]
  ypoints=ypoints[1:n_elements(ypoints)-1]
  points = intarr(2, n_elements(xpoints))
  points[0, *] = xpoints
  points[1, *] = ypoints
  n = n_elements(xpoints)
  return, points

end
