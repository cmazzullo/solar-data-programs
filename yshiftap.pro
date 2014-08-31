; Example:
; yuwant = yshiftap(wl, w10, y0)
; Where wl is the wavelength you want, wl0 is the wavelength
; of the line you used to choose the pixels and y0 is the y
; value of the pixel you used in the base picture

function yshiftap,wl,wl0,y0
sl1=.08718
sl2=.076586
if wl lt 220. then begin
y=y0+sl1*(wl-wl0)
return,y
endif else begin
y=y0+11.649+sl2*(wl-wl0)
return,y
endelse
end
