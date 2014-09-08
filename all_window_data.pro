function all_window_data, file, windowNs ; level 1 file, window #s

  data = eis_getwindata(file, 0, /refill)
  data_struct = create_struct('filename', file, 'window_numbers', windowNs)

  for j = 0, (n_elements(windowNs) - 1) do begin
     windowN = windowNs[j]      ;which data window to view
     data = eis_getwindata(file, windowN, /refill)
     data_struct = create_struct(data_struct, string(j), data)
  endfor

  return, data_struct

end
