;; Gets all of the window data for all of the windows listed in
;; windowNs out of a given file and returns it in a big struct.

function all_window_data, file, windowNs ; level 1 file, window #s

  data = eis_getwindata(file, 0, /refill, /quiet)
  data_struct = create_struct('filename', file, 'window_numbers', windowNs)

  for j = 0, (n_elements(windowNs) - 1) do begin
     windowN = windowNs[j]      ;which data window to view
     data = eis_getwindata(file, windowN, /refill, /quiet)
     tag = 'window_' + strtrim(string(windowN), 1)
     data_struct = create_struct(data_struct, tag, data)
  endfor

  return, data_struct

end
