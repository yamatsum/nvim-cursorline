if exists('g:loaded_cursorword') || v:version < 703
  finish
endif
let g:loaded_cursorword = 1

let s:save_cpo = &cpo
set cpo&vim

lua require'nvim-cursorline'.cursormoved()
lua require'nvim-cursorline'.highlight()

let &cpo = s:save_cpo
unlet s:save_cpo
