# nvim-cursorline

Highlight words and lines on the cursor for Neovim

- Underlines the word under the cursor.
- Show / hide cursorline in connection with cursor moving.

![demo](https://user-images.githubusercontent.com/42740055/102508634-f4d26c80-40c8-11eb-90af-142a7a63837d.gif)

## Installation

Install with your favorite plugin manager.

## Usage

```lua
require('nvim-cursorline').setup {
  cursorline = {
    enable = true,
    timeout = 1000,
    number = false,
  },
  cursorword = {
    enable = true,
    min_length = 3,
    hl = { underline = true },
  }
}
```

## Acknowledgments

Thanks goes to these people/projects for inspiration:

- [delphinus/vim-auto-cursorline](https://github.com/delphinus/vim-auto-cursorline)
- [itchyny/vim-cursorword](https://github.com/itchyny/vim-cursorword)

## License

This software is released under the MIT License, see LICENSE.
