function testing

  folder = "/swd4/Users/EIS/cmazzullo/solar-data-programs/"
  basename = "eis_l1_20110329_094224.fits"

  file = folder + basename
  windowNs = [0, 3, 6, 8, 9, 21, 23, 24] ; wavelen windows to look at
  out = all_window_data(file, windowNs)
  return, out
end
