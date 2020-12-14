if exists('g:loaded_cursorword') || v:version < 703
  finish
endif
let g:loaded_cursorword = 1

let s:save_cpo = &cpo
set cpo&vim

autocmd VimEnter * call luaeval("require'nvim-cursorline'.highlight()")
autocmd CursorMoved,CursorMovedI * call luaeval("require'nvim-cursorline'.cursormoved()")

let &cpo = s:save_cpo
unlet s:save_cpo
