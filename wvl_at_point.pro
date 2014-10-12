; INPUT:
;   data: the data window returned from eis_getwindata
;   x, y: the point to consider
;   abswl_shift: the shift returned from abswl.pro
;   wvl_corr: a manual wavelength correction 
; OUTPUT:
;   fitwvl: the corrected wavelength of the light at the point

function wvl_at_point, x, y, data, abswl_shift, wvl_corr, estimates=est

  ; first use mfitpeak to fit a gaussian to the intensity  
  if keyword_set(est) then begin
     fit = mpfitpeak(data.wvl, data.int[*, x, y], output, nterms=4, $
                     error=data.err[*, x, y], estimates=est[1:*])
  endif else begin
     fit = mpfitpeak(data.wvl, data.int[*, x, y], output, nterms=4, $
                     error=data.err[*, x, y])
  endelse

  wvl = output[1]

  ; then use wave_corr to correct for orbital variations
  ; and add the absolute wavelength shift and manual correction
  wvl = wvl - data.wave_corr[x, y] + abswl_shift + wvl_corr
  return, wvl

end
