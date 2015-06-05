;; BEWARE: No abswl shift is applied!
;; Format for the vel_cube: [window_number, x, y]

function all_v, dws, abswl_shift
  print, 'hello'
  windowNs = dws.window_numbers
  N = n_elements(windowNs)
  win = get_window(dws, windowNs[0])
  xdim = win.nx
  ydim = win.ny
  print, N, xdim, ydim
  vel_cube = dblarr(N, xdim, ydim)
  for i=0, N-1 do begin
     print, 'Processing window ', i
     win = get_window(dws, windowNs[i])
     vel_out = draw_velocity(win, abswl_shift)
     vel_cube[i, *, *] = vel_out
  endfor
  return, vel_cube
end
