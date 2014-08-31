function interpap,y,x,x0
ny=size(x)
ny=ny(1)-1
for i=1,ny do begin
if x(i) ge x0 then begin
m=i
ans=y(m-1)+(y(m)-y(m-1))/(x(m)-x(m-1))*(x0-x(m-1))
if (y(m) eq 0. ) or (y(m-1) eq 0.) then ans=-1.
return, ans
endif
endfor
ans=y(ny)
return,ans
end

