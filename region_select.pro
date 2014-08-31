function region_select, data

; First, define a boundary around the region
  points = tv_select(data.int, npoints)
  inside = points[*, npoints - 1]
  vertices = points[*, 0 : npoints - 2]
  boundary = vertices
  for i = 0, npoints - 2 do begin
     x1 = vertices[0, i]
     y1 = vertices[1, i]

     if (i eq (npoints - 2)) then j = 0 else j = i + 1

     x2 = vertices[0, j]
     y2 = vertices[1, j]

     if ((x2 - x1) eq 0) then begin 
        m = 'Inf'
     endif else begin 
        m = (y2 - y1) / double(x2 - x1)
     endelse

     if (m eq 'Inf') then begin
        y = indgen(abs(y1 - y2) - 1) + (y1 < y2) + 1
        x = intarr(abs(y1 - y2) - 1) + y1
     endif else if (abs(m) ge 1) then begin
        y = indgen(abs(y1 - y2) - 1) + (y1 < y2) + 1
        x = round(x1 + (y - y1) / double(m))
     endif else begin
        x = indgen(abs(x1 - x2) - 1) + (x1 < x2) + 1
        y = round(y1 + (x - x1) * double(m))
     endelse

     array = intarr(2, n_elements(x))
     array(0, *) = x
     array(1, *) = y
     boundary = [[boundary], [array]]
  endfor

; Next, populate the inside of the region
  x = get_interior(boundary, inside[0, 0], inside[1, 0])
  plot, x(0, *), x(1, *), psym=4, xrange=[0, 200], yrange=[0, 500]  
  return, x

end
