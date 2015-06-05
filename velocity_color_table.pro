pro velocity_color_table
  steps = 256                   ; how many intermediary colors
  hi = 255                      ; brightest color
  r = [replicate(hi, steps / 2), hi*(1-2*findgen(steps/2.0)/(steps-1))]
  g = [2*hi*findgen(steps/2.0)/(steps-1), hi*(1-2*findgen(steps/2.0)/(steps-1))]
  b = [2*hi*findgen(steps/2.0)/(steps-1), replicate(hi, steps/2)]
  tvlct, r, g, b
end