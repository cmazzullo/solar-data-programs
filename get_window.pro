;; Grabs a window by number out of the struct
function get_window, struct, index
  tag = 'window_' + strtrim(string(index), 1)
  void = execute('window = struct.' + tag)
  return, window
end
