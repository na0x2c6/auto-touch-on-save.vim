" Test suite
let s:suite = themis#suite('auto_touch_on_save')
let s:assert = themis#helper('assert')

function! s:suite.before_each() abort
  call test_override('ALL', 0)  " Reset all overrides
  source autoload/auto_touch_on_save.vim
  let g:auto_touch_on_save_condition = 'exit 0'
  let g:auto_touch_on_save_command = 'touch'
  let g:auto_touch_on_save_path_converter = ''
  if exists('*g:AutoTouchOnSavePathConverter')
    delfunction g:AutoTouchOnSavePathConverter
  endif
endfunction

function! s:suite.after_each() abort
  call test_override('ALL', 0)  " Reset all overrides
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
  call test_override('starting', 1)
  let g:auto_touch_on_save_path_converter = 'sed "s|^|/shell_converted|"'
  call s:assert.equal(auto_touch_on_save#convert_path('/test/path'), '/shell_converted/test/path')
  let g:auto_touch_on_save_path_converter = ''
  call test_override('starting', 0)
endfunction

function! s:suite.test_convert_path_prefer_vim_function() abort
  call test_override('starting', 1)
  function! g:AutoTouchOnSavePathConverter(path) abort
    return '/vim_preferred' . a:path
  endfunction
  let g:auto_touch_on_save_path_converter = 'sed "s|^|/shell_converted|"'
  call s:assert.equal(auto_touch_on_save#convert_path('/test/path'), '/vim_preferred/test/path')
  delfunction g:AutoTouchOnSavePathConverter
  let g:auto_touch_on_save_path_converter = ''
  call test_override('starting', 0)
endfunction

function! s:suite.test_execute_condition_true() abort
  call test_override('starting', 1)
  let temp_file = tempname()
  call writefile(['test content'], temp_file)
  call system('touch -m -t 202201010000.00 ' . shellescape(temp_file))
  let initial_mtime = getftime(temp_file)
  let g:auto_touch_on_save_condition = 'exit 0'
  call auto_touch_on_save#execute(temp_file)
  let updated_mtime = getftime(temp_file)
  call s:assert.true(updated_mtime > initial_mtime)
  call delete(temp_file)
  call test_override('starting', 0)
endfunction

function! s:suite.test_execute_condition_false() abort
  call test_override('starting', 1)
  let temp_file = tempname()
  call writefile(['test content'], temp_file)
  call system('touch -m -t 202201010000.00 ' . shellescape(temp_file))
  let initial_mtime = getftime(temp_file)
  let g:auto_touch_on_save_condition = 'exit 1'
  call auto_touch_on_save#execute(temp_file)
  let updated_mtime = getftime(temp_file)
  call s:assert.equal(updated_mtime, initial_mtime)
  call delete(temp_file)
  call test_override('starting', 0)
endfunction

function! s:suite.test_run_command() abort
  call test_override('starting', 1)
  let temp_file = tempname()
  call writefile(['test content'], temp_file)
  call system('touch -m -t 202201010000.00 ' . shellescape(temp_file))
  let initial_mtime = getftime(temp_file)
  call auto_touch_on_save#run_command(temp_file)
  let updated_mtime = getftime(temp_file)
  call s:assert.true(updated_mtime > initial_mtime)
  call delete(temp_file)
  call test_override('starting', 0)
endfunction

function! s:suite.test_reload_file() abort
  call test_override('starting', 1)
  let temp_file = tempname()
  call writefile(['test content'], temp_file)
  execute 'edit ' . temp_file
  call auto_touch_on_save#reload_file(temp_file)
  call s:assert.equal(getline(1), 'test content')
  call delete(temp_file)
  bdelete!
  call test_override('starting', 0)
endfunction
