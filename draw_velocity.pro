FUNCTION DRAW_VELOCITY, FILE1, vel_corr
  windowN = 8
  data = eis_getwindata(file1, windowN, /refill, /quiet)
;120 x 512
  output = dblarr(120, 512)
  for i = 0, 119 do begin
     for j = 0, 511 do begin
        v = vel_at_point(i, j, data, windowN, vel_corr)
        output[i, j] = v
     endfor 
  endfor 

return, output

END
