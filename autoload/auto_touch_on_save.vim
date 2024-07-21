function! auto_touch_on_save#system(cmd)
  return system(a:cmd)
endfunction

function! auto_touch_on_save#execute() abort
  if auto_touch_on_save#check_condition()
    call auto_touch_on_save#run_command()
    call auto_touch_on_save#reload_file()
  endif
endfunction

function! auto_touch_on_save#check_condition() abort
  let l:result = auto_touch_on_save#system(g:auto_touch_on_save_condition)
  return v:shell_error == 0
endfunction

function! auto_touch_on_save#run_command() abort
  let l:path = expand('%:p')
  let l:path = auto_touch_on_save#convert_path(l:path)
  let l:command = g:auto_touch_on_save_command . ' ' . shellescape(l:path)
  call auto_touch_on_save#system(l:command)
endfunction

function! auto_touch_on_save#convert_path(path) abort
  if exists('*g:AutoTouchOnSavePathConverter')
    " User-defined function exists, use it
    return g:AutoTouchOnSavePathConverter(a:path)
  elseif !empty(g:auto_touch_on_save_path_converter)
    " Fall back to the string command if set
    return trim(auto_touch_on_save#system(g:auto_touch_on_save_path_converter . ' ' . shellescape(a:path)))
  endif
  " If no conversion is set, return the original path
  return a:path
endfunction

function! auto_touch_on_save#reload_file() abort
  let l:current_view = winsaveview()
  checktime
  call winrestview(l:current_view)
endfunction
