pro plot_wavelength, data

  abswl_shift = 0
  vel_corr = 0

  for x=0, 119 do begin
     for y=0, 512 do begin
        wvls[x, y] = wvl_at_point(x, y, data, abswl_shift, vel_corr)
        output[i, j, 2] = fitvel
     endfor
  endfor
end
