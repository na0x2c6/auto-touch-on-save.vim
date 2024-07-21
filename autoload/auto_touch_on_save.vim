function! auto_touch_on_save#execute(path) abort
  if !auto_touch_on_save#check_condition()
    return
  endif
  call auto_touch_on_save#run_command(a:path)
  call auto_touch_on_save#reload_file(a:path)
endfunction

function! auto_touch_on_save#check_condition() abort
  let l:result = system(g:auto_touch_on_save_condition)
  return v:shell_error == 0
endfunction

function! auto_touch_on_save#run_command(path) abort
  let l:path = auto_touch_on_save#convert_path(fnamemodify(a:path, ':p'))
  let l:command = g:auto_touch_on_save_command . ' ' . shellescape(l:path)
  call system(l:command)
endfunction

function! auto_touch_on_save#convert_path(path) abort
  if exists('*g:AutoTouchOnSavePathConverter')
    " User-defined function exists, use it
    return g:AutoTouchOnSavePathConverter(a:path)
  elseif !empty(g:auto_touch_on_save_path_converter)
    " Fall back to the string command if set
    return trim(system(g:auto_touch_on_save_path_converter, a:path))
  endif
  " If no conversion is set, return the original path
  return a:path
endfunction

function! auto_touch_on_save#reload_file(path) abort
  if !bufexists(a:path)
    return
  endif

  execute 'checktime ' . a:path
endfunction
