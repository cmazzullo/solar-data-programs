;; Plot velocity against distance along the loop with errorbars.
;; INPUTS: data, the output of window_velocity
;;         windowN, the number of the window to look at

pro errorbars, data, windowN
  xs = data[*, windowN, 0]
  ys = data[*, windowN, 1]
  distances = sqrt((xs - xs[0])^2 + (ys - ys[0])^2)
  vs = data[*, windowN, 3]
  errs = data[*, windowN, 2]
  plot, distances, vs, psym=1
  errplot, distances, vs - errs, vs + errs
end
