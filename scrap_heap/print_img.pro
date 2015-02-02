pro print_img, image, filename
; Save device settings and tell IDL to use a color table
  DEVICE, GET_DECOMPOSED=old_decomposed
  DEVICE, DECOMPOSED=0
  LOADCT, 0
; Create an image and display it
  size = size(image)
  WINDOW, 1, XSIZE=size[1], YSIZE=size[2], XPOS=100, YPOS=100
  TVSCL, IMAGE
; Note the use of the TRUE keyword to TVRD
  WRITE_PNG, filename, TVRD(/TRUE)
  PRINT, 'File written to ', filename
end
