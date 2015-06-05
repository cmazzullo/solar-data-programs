;; A quick and dirty, totally nonportable script to get velocity
;; output into a text file

pro dump_velocity_output, filename, dws
  out = window_velocity(dws)
  openw, 1, filename
  size = size(out)
  xdim = size[1]
  ydim = size[2]
  zdim = size[3]
  fmt = '(f'
  for i=1, xdim-1 do fmt += ',f'
  fmt += ',$)'
  for z=0,zdim-1 do begin
     printf, 1, out[*, *, z], format=fmt
     printf, 1, string(10B)+string(10B)
  endfor
  close, 1
end
