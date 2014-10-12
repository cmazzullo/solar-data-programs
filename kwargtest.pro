function kwargtest, x, kwarg=hello
  if keyword_set(kwarg) then print, "hello!"
  return, 0
end
