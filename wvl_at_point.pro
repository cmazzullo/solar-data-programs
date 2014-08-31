; INPUT:
;   data, which contains the intensity array and wavelength array
; OUTPUT:
;   fitwvl, which is the fitted wavelength at the point
; ADD THE ERROR ARRAY AS AN INPUT
; also we need to apply the offset
FUNCTION WVL_AT_POINT, X, Y, DATA
; First use mfitpeak to fit a gaussian to the intensity
  fit = mpfitpeak(data.wvl, data.int[*, x, y], output, nterms=4)
  wvl = output[1]
; Then use wave_corr to correct for orbital variations
; and add the absolute wavelength shift 

  abswlshift = 0                ;NEED ACTUAL ABSOLUTE SHIFT

  wvl = wvl - data.wave_corr[x, y] + abswlshift
;;  print, "Wavelength found by wvl_at_point: ", wvl
  return, wvl

END
