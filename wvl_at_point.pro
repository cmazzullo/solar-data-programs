; INPUT:
;   X, Y: the point to consider
;   DATA: the data window returned from eis_getwindata
;   ABSWL_SHIFT: the wavelength shift to add to the data as returned
;   from abswl.pro
;   WVL_CORR: a manual wavelength correction
;   ESTIMATES: for windows with more than one line, it may be
;   necessary to supply mpfitpeak with initial guesses
;
; OUTPUT:
;   An array containing the wavelength of the line and the sigma of
;   the fit (the width of the line). Format: [fitvel, sigma]

function wvl_at_point, x, y, data, abswl_shift, wvl_corr, estimates=est

  ;; If estimates are given, use them in the fit.
  if keyword_set(est) then begin
     fit = mpfitpeak(data.wvl, data.int[*, x, y], output, nterms=4, $
                     error=data.err[*, x, y], estimates=est[1:*])
  endif else begin
     fit = mpfitpeak(data.wvl, data.int[*, x, y], output, nterms=4, $
                     error=data.err[*, x, y])
  endelse

  wvl = output[1]               ; Centroid of the Gaussian
  sigma = output[2]             ; Gaussian sigma (uncertainty)

  ; then use wave_corr to correct for orbital variations
  ; and add the absolute wavelength shift and manual correction
  wvl = wvl - data.wave_corr[x, y] + abswl_shift + wvl_corr
  return, [wvl, sigma]

end
