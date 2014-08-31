pro abswl,wd,mx,my,offset,params
;wd is structure, x,y is 2Darray defining lower left and upper right of box
;in pixel numbers
;offset is the wl offset as a function of position, abs is the shift to
;get absolute wl, abswl=wl-offset(i,j)-abs 
  mx=fltarr(2)
  my=fltarr(2)
  wl=wd.wvl
  int=wd.int
  intav=average(int,1)
  intav=reform(intav)
  exptv,intav
  tvpos,x1,y1
  wait, 0.5
  mx(0)=x1
  my(0)=y1
  tvpos,x1,y1
  wait,0.5
  mx(1)=x1
  my(1)=y1
  print,mx,my,' above are  x,y of box'
  nwl=size(wl)
  nwl=nwl(1)
;print,nwl,'  nwl'
  nx=mx(1)-mx(0)
  ny=my(1)-my(0)
;get an average line profile for the area with wl being the reference wl
  av=fltarr(nwl)
  wl1=fltarr(nwl)
  m=fltarr(nwl)
  for i=mx(0),mx(1) do begin
     for j=my(0),my(1) do begin
        wl1=wl-offset(i,j)
                                ;need to watch out for points less than 0
        
        for k=0,nwl-1 do begin
           f=interpap(int(*,i,j),wl1,wl(k))
           if f gt 0. then begin
              av(k)=av(k)+f
              m(k)=m(k)+1.
           endif
        endfor
;  Print,m,av,' m average'
;  print,wl1,offset(i,j),' wl1,offset put in a dummy number to continue'
;   plot,wl,av 
;  read,z
     endfor
  endfor
  av=av/m
  plot,wl,av,psym=1
  print,m,'  number of points at each wl'
; so now I have the average profile on the wl scale
  fit=mpfitpeak(wl,av,prams,nterms=4)
  params=prams
;abs=params(1)
;this returns the wavelength found for the line 
  return
end
