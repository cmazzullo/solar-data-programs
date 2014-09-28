pro brightplot, window
  intav = average(window.int, 1)
  point = mymax(intav)
  plot, window.wvl, window.int(*, point[0], point[1])
end
