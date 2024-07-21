let s:suite = themis#suite('auto_touch_on_save')
let s:assert = themis#helper('assert')

function! s:suite.before_each() abort
  source autoload/auto_touch_on_save.vim
  let g:auto_touch_on_save_condition = 'true'
  let g:auto_touch_on_save_command = 'touch'
  let g:auto_touch_on_save_path_converter = ''
  if exists('*g:AutoTouchOnSavePathConverter')
    delfunction g:AutoTouchOnSavePathConverter
  endif
endfunction

function! s:suite.test_check_condition_true() abort
  let g:auto_touch_on_save_condition = 'true'
  call s:assert.equal(auto_touch_on_save#check_condition(), 1)
endfunction

function! s:suite.test_check_condition_false() abort
  let g:auto_touch_on_save_condition = 'false'
  call s:assert.equal(auto_touch_on_save#check_condition(), 0)
endfunction

function! s:suite.test_convert_path_no_converter() abort
  call s:assert.equal(auto_touch_on_save#convert_path('/test/path'), '/test/path')
endfunction

function! s:suite.test_convert_path_vim_function() abort
  function! g:AutoTouchOnSavePathConverter(path) abort
    return '/vim_converted' . a:path
  endfunction
  call s:assert.equal(auto_touch_on_save#convert_path('/test/path'), '/vim_converted/test/path')
  delfunction g:AutoTouchOnSavePathConverter
endfunction

function! s:suite.test_convert_path_shell_command() abort
  let g:auto_touch_on_save_path_converter = 'printf /shell_converted%s'
  call s:assert.equal(auto_touch_on_save#convert_path('/test/path'), '/shell_converted/test/path')
  let g:auto_touch_on_save_path_converter = ''
endfunction

function! s:suite.test_convert_path_prefer_vim_function() abort
  function! g:AutoTouchOnSavePathConverter(path) abort
    return '/vim_preferred' . a:path
  endfunction
  let g:auto_touch_on_save_path_converter = 'printf /shell_converted%s'
  call s:assert.equal(auto_touch_on_save#convert_path('/test/path'), '/vim_preferred/test/path')
  delfunction g:AutoTouchOnSavePathConverter
  let g:auto_touch_on_save_path_converter = ''
endfunction
