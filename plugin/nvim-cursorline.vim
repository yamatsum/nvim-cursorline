if exists('g:loaded_cursorword') || v:version < 703
  finish
endif
let g:loaded_cursorword = 1

let s:save_cpo = &cpo
set cpo&vim

autocmd VimEnter * call luaeval("require'nvim-cursorline'.highlight_cursorword()")
autocmd CursorMoved,CursorMovedI * call luaeval("require'nvim-cursorline'.cursor_moved()")
autocmd WinEnter * call luaeval("require'nvim-cursorline'.win_enter()")
autocmd WinLeave * call luaeval("require'nvim-cursorline'.win_leave()")

let &cpo = s:save_cpo
unlet s:save_cpo
