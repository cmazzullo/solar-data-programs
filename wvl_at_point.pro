; INPUT:
;   data, which contains the intensity array and wavelength array
; OUTPUT:
;   fitwvl, which is the fitted wavelength at the point
; ADD THE ERROR ARRAY AS AN INPUT
; also we need to apply the offset

function wvl_at_point, x, y, data, abswl_shift

  ; first use mfitpeak to fit a gaussian to the intensity

  fit = mpfitpeak(data.wvl, data.int[*, x, y], output, nterms=4)
  wvl = output[1]

  ; then use wave_corr to correct for orbital variations
  ; and add the absolute wavelength shift 

  wvl = wvl - data.wave_corr[x, y] + abswl_shift
  ;;  print, "wavelength found by wvl_at_point: ", wvl
  return, wvl

end
