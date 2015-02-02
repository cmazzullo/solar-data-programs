;; Takes dws, which contains all window data, and vel_cube, which
;; contains all velocity data and exports them to a series of
;; whitespace-delimited files in the current directory
;; Header data:
;; # fits_fname
;; # window line
;; # window number

pro export_all, dws, vel_cube
  fits_fname = dws.filename
  windowNs = dws.window_numbers
  for i = 0, n_elements(windowNs)-1 do begin
     winN = windowNs[i]
     winstr = string(winN, format='(i02)')
     fname = 'win_' + winstr + '_vel.csv'
     win = get_window(dws, winN)
     line_id = win.line_id
     newline = string(10B)
     header = '# FITS file: '+ fits_fname + newline + $
              '# Window number: '+ winstr + newline + $
              '# Window line: '+ line_id + newline
     data = reform(vel_cube[i, *, *])
     print, 'fname = ', fname
     write_csv, fname, data, header=header
  endfor
end
