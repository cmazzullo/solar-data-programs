;; Data must be a one- or two-dimensional array

pro write_csv, filename, data, header=header
  size = size(data)
  dim = size[0]
  if dim > 2 then begin
     print, "Can only write 1- and 2-dimensional arrays.\n", $
            "Your array has too many dimensions."
  endif else begin
     if dim eq 1 then n = 1
     if dim eq 2 then n = size[1]
     openw, 1, filename
     if keyword_set(header) then printf, 1, header
     printf, 1, data, format='(' + string(n) + '(D))'
     close, 1
  endelse
end
