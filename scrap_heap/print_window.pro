pro print_window, window, filename
  int = window.int
  intav = average(int, 1)
  print_img, intav, filename
end
