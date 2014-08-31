FUNCTION READ_INIT_FILE, FNAME

  print, "WARNING: This program reads and evals a file named ", fname, $
         "in the directory where it is run. If you don't have an ", $
         "init file, or if it's messed up, you'll get incorrect results!"
  print, 'Reading init file ',  fname, '...'
  
  OPENR, lun, fname, /GET_LUN
  array = ''
  line = ''
  R = 1
  WHILE NOT EOF(lun) AND R DO BEGIN
     READF, lun, line
     R = execute(line)
  ENDWHILE
  FREE_LUN, lun

  init_data = {lit_wvls : lit_wvls, l1_file : file1}
  RETURN, INIT_DATA
END
