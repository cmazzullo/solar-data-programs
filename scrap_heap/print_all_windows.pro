;; Print the intensity images from all of the windows in dws

pro print_all_windows, dws, directory
  windowNs = dws.window_numbers
  for i=0, n_elements(windowNs)-1 do begin
     windowN = windowNs[i]
     win = get_window(dws, windowN)
     filename = directory + '/window' + strtrim(string(windowN), 1) + '.png'
     print_window, win, filename
  endfor
end
