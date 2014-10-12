function wvl_image, data
  abswl_shift = 0
  vel_corr = 0
  wvls = dblarr(120, 512)
  for x=0, 119 do begin
     for y=0, 511 do begin
        wvls[x, y] = wvl_at_point(x, y, data, abswl_shift, vel_corr)
     endfor
  endfor
  return, wvls
end
