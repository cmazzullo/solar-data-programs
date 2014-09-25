;; X and Y are the coordinates that we're looking at
;; DATA is the struct containing all of the intensity data and such
;; WINDOWN is the Window Number of the data set we're considering
;; LIT_WVLS is an array containing the wavelengths according to
;; the literature

function vel_at_point, x, y, data, windown, lit_wvls, abswl_shift, vel_corr
  
  wvl = wvl_at_point(x, y, data, abswl_shift, vel_corr)

  delwvl = wvl - lit_wvls[windowN]
  c = 3 * 10^5                  ; Speed of light in km/s
  v = c * delwvl / lit_wvls[windowN]

  return, v

end
