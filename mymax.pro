function mymax, window
  val = max(window, index)
  winsize = size(window)
  l = winsize[1]
  x = index mod l
  y = index / l
  return, [x, y]
end
