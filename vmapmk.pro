pro vmapmk,data,vmaps
c=3.*10.^5
dimen=size(data)
nwls=dimen(1)
vmaps=fltarr(nwls,dimen(3),dimen(4))
print,dimen
wl0=dblarr(nwls)
wl0(0)=180.401   ; fexi
wl0(1)=185.213  ; feviii
wl0(2)=192.394  ; fexii also a weaker Fexi line at 192.8+
wl0(3)=195.119  ; fexii
wl0(4)=197.860  ; Feix
wl0(5)=276.153  ; Mgvii .153 or Fexii at .364???
wl0(6)=280.740 ; Mgvii at .737
wl0(7)=284.160 ; fexv seems to be a solid line
if nwls ne 8 then begin
print,'error in lab wavelengths'
return
endif
dat1=dblarr(dimen(3),dimen(4))  ; to set up the dimension
for i=0,nwls-1 do begin
dat1(*,*)=reform(data(i,1,*,*))
nx=where(dat1 eq 0.)
dat1(nx)=wl0(i)   ; this will give a 0 velocity
vmaps(i,*,*)=(dat1(*,*)-wl0(i))/wl0(i)*c
endfor
return
end

