if exists('g:loaded_cursorword') || v:version < 703
  finish
endif
let g:loaded_cursorword = 1

let s:save_cpoptions = &cpoptions
set cpoptions&vim

augroup cursorline
  autocmd! VimEnter * call luaeval("require'nvim-cursorline'.vim_enter()")
  autocmd! CursorMoved,CursorMovedI * call luaeval("require'nvim-cursorline'.cursor_moved()")
  autocmd! BufEnter * call luaeval("require'nvim-cursorline'.buf_enter()")
  autocmd! BufLeave * call luaeval("require'nvim-cursorline'.buf_leave()")
augroup END

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
