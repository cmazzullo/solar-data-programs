; Makes an empty 'list'

function make_list
  r = {void: ''}
  return, r
end  

function set, list, index, value
  index_str = string(index)
  index_str = strtrim(index_str, 1)
  index_str = 'i' + index_str
  list = create_struct(list, index_str, value)
  return, list
end

function get, list, index
  index_str = strtrim(string(index), 1)
  element = ''
  void = execute('element = list.i' + index_str)
  return, element
end

function get_indices, list
  tags = tag_names(list)
  indices = intarr(n_elements(tags) - 1)
  for i = 0, (n_elements(tags) - 1) do begin
     if tags[i] ne 'VOID' then begin
        indices[i] = tag_to_index(tags[i])
     endif else begin
        i = i - 1
     endelse
  endfor
  return, indices
end

function push, list, value
  index = max(get_indices(list)) + 1
  list = set(list, index, value)
  return, list
end

function tag_to_index, tag 
  a = strsplit(tag, 'i')
  return, fix(a[0])
end
