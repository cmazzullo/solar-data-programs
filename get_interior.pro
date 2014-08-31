FUNCTION GET_INTERIOR, B, X, Y  ;where b is the boundary

 if (max((b[0, *] eq x) + (b[1, *] eq y)) eq 2) then begin
     return, b
  endif

;  for i = 0, n_elements(b[0, *]) - 1 do begin
;     bx = b[0, i]
;     by = b[1, i]
;     if ((bx eq x) and (by eq y)) then return, b
;  endfor

  x = where(b eq [x, y])
  b = [[b], [x, y]]
  b = get_interior(b, x - 1, y)
  b = get_interior(b, x + 1, y)
  b = get_interior(b, x, y - 1)
  b = get_interior(b, x, y + 1)
  return, b

END
