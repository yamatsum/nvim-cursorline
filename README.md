# nvim-cursorline

Highlight words and lines on the cursor for Neovim

- Underlines the word under the cursor.
- Show / hide cursorline in connection with cursor moving.

![demo](https://user-images.githubusercontent.com/42740055/102508634-f4d26c80-40c8-11eb-90af-142a7a63837d.gif)

## Installation
Install with your favorite plugin manager.

## Highlighting
You can override cursor highlighting by defining `CursorWord` group and disabling built-in highlighting by specifying `vim.g.cursorword_highlight` (lua) or `g:cursorword_highlight` (vimscript).

To lower the time it takes to make the cursorline appear, set `vim.g.cursorline_timeout` (lua) or `g:cursorline_timeout` (vimscript), where `1000` is the default value in milliseconds.

To disable the cursorline set `vim.g.cursorline_highlight` (lua) `g:cursorline_highlight` (vimscript) to `false`.

To disable the cursorline or cursorword on certain filetypes or buffers set `vim.g.cursorline_disabled_filetypes`, `vim.g.cursorline_disabled_buftypes`, `vim.g.cursorword_disabled_filetypes`, `vim.g.cursorword_diesabled_buftypes` (lua) `g:cursorline_disabled_filetypes`, `g:cursorline_disabled_buftypes`, `g: cursorword_disabled_filetypes`, `g:cursorword_diesabled_buftypes` (vimscript) as tables (for multiple filetypes/buftypes) or strings (for single filetype/buftype).
In example, setting `vim.g.cursorline_disabled_filetypes = {"NvimTree"}` (lua) `let g:cursorline_disabled_filetypes = ["NvimTree"]` (vimscript) disables the cursorline for the [nvim-tree](https://github.com/kyazdani42/nvim-tree.lua).

## Acknowledgments
Thanks goes to these people/projects for inspiration:

- [delphinus/vim-auto-cursorline](https://github.com/delphinus/vim-auto-cursorline)
- [itchyny/vim-cursorword](https://github.com/itchyny/vim-cursorword)

## License
This software is released under the MIT License, see LICENSE.
