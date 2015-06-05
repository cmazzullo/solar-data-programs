function draw_velocity, data, abswl_shift
  windowN = data.iwin
  nx = data.nx
  ny = data.ny
  @init
  output = dblarr(nx, ny)
  for i = 0, nx-1 do begin
     for j = 0, ny-1 do begin
        v_arr = vel_at_point(i, j, data, windowN, lit_wvls, abswl_shift, vel_corr)
        v = v_arr[0]
        output[i, j] = v
     endfor
     print, '% done = ', 100.0 * i / nx
  endfor
return, output
end
