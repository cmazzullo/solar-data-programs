function yshift2, wl, wl0, y0

  m1 = 0.08718
  m2 = 0.076586
  wls = 220.0 ; the wavelength where the big jump occurs
  ys = 11.649 ; the magnitude of the jump

  case 1 of
     (wl le wls) and (wl0 lt wls): y = m1*(wl - wl0)
     (wl ge wls) and (wl0 gt wls): y = m2*(wl - wl0)
     (wl ge wls) and (wl0 lt wls): y = m1*(wls - wl0) + m2*(wl - wls) + ys
     (wl le wls) and (wl0 gt wls): y = m1*(wl - wls) + m2*(wls - wl0) - ys
  endcase

  return, y + y0
end
