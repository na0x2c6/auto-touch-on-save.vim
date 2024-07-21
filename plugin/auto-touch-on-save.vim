if exists('g:loaded_auto_touch_on_save') | finish | endif
let g:loaded_auto_touch_on_save = 1

" for default
let g:auto_touch_on_save_condition = get(g:, 'auto_touch_on_save_condition', 'true')
let g:auto_touch_on_save_command = get(g:, 'auto_touch_on_save_command', 'touch')
let g:auto_touch_on_save_path_converter = get(g:, 'auto_touch_on_save_path_converter', '')

augroup AutoTouchOnSave
  autocmd!
  autocmd BufWritePost * call auto_touch_on_save#execute()
augroup END
