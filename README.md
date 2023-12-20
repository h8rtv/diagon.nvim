# diagon.nvim
Wrapper for [Diagon](https://github.com/ArthurSonzogni/Diagon) interpreter directly inside neovim. Rewrite of the [vim-diagon](https://github.com/willchao612/vim-diagon) plugin using lua and plenary to communicate with the diagon CLI.

## Prerequisites

Diagon CLI is necessary. It can be installed from the Snap Store.

```bash
sudo snap install diagon
```

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'h8rtv/diagon.nvim',
  cmd = 'Diagon', -- Load only when calling the Diagon command
  lazy = true,
  opts = {},
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
  },
},
```

## Usage

Write your Diagon input and visually select it. Then run the command `:Diagon <translator>`. It will write the output in the current buffer.
You can select inside a comment block and the output will be commented too.

[](https://github.com/h8rtv/diagon.nvim/assets/26033412/d13c14ae-8bb9-49b1-b178-6924110c62c3)

## Configuration

These are the default configuration options. 

```lua
local defaults = {
    pos = 'substitute', -- 'above' | 'below' | 'substitute' -- You can select the result will substitute de input, be written above or bellow.
    translators = { -- You can select the allowed translators.
        'Math',
        'Sequence',
        'Tree',
        'Table',
        'Grammar',
        'Frame',
        'GraphDAG',
        'GraphPlanar',
        'Flowchart',
    },
}
```

## Credits

[Diagon](https://github.com/ArthurSonzogni/Diagon)

[vim-diagon](https://github.com/willchao612/vim-diagon)
