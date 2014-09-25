;; Reads the file specified in the init file, putting all of its 
;; wavelength windows into a structure
function auto_get_windows
  init_data = read_init_file('init.txt')
  file = init_data.l1_file
  windowNs = init_data.windowNs
  out = all_window_data(file, windowNs)
  return, out
end
