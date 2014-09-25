function brightest_point, int_avg, x, y, l ; l is box size

  window = int_avg[(x-l):(x+l), (y-l):(y+l)]
  val = max(window, index)
  xw = index mod (2*l + 1)
  yw = index / (2*l + 1)
  ix = x + xw - l
  iy = y + yw - l
  return, [ix, iy]

end
