function read_history_file, fname

  openr, lun, fname, /get_lun
  line = ''
  readf, lun, line
  free_lun, lun
  return, line
  
end
