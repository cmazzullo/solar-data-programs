;; This function returns the velocity moving *towards you*

;; X and Y are the coordinates that we're looking at
;; DATA is the struct containing all of the intensity data and such
;; WINDOWN is the Window Number of the data set we're considering
;; LIT_WVLS is an array containing the wavelengths according to
;; the literature

function vel_at_point, x, y, data, windown, lit_wvls, abswl_shift, vel_corr, estimates=est

  if keyword_set(est) then begin
     wvl_arr = wvl_at_point(x, y, data, abswl_shift, vel_corr, estimates=est)
     lit_wvl = est[2]
  endif else begin
     wvl_arr = wvl_at_point(x, y, data, abswl_shift, vel_corr)
     lit_wvl = lit_wvls[windowN]
  endelse

  wvl = wvl_arr[0]
  sigma = wvl_arr[1]

  delwvl = lit_wvl - wvl
  c = 3 * 10^5                  ; Speed of light in km/s
  v = c * delwvl / lit_wvl
  return, [v, sigma]

end
