# nvim-logbook

A Neovim plugin for maintaining daily logs and notes with timestamps.

## Features

- Create and manage dated logbook entries
- Easy timestamp insertion
- Configurable file locations and date formats
- Auto-completion for existing logbook files

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "yourusername/nvim-logbook",
  config = function()
    require("logbook").setup({
      -- your configuration here
    })
  end
}
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  'yourusername/nvim-logbook',
  config = function()
    require('logbook').setup()
  end
}
```

## Configuration

```lua
require('logbook').setup({
  default_path = '~/logbook',
  date_format = '%Y-%m-%d %H:%M:%S',
  file_extension = '.md'
})
```

## Usage

- `:LogbookOpen [name]` - Opens or creates a logbook file
- `:LogbookInsertTimestamp` - Inserts current timestamp at cursor position

Default keymaps:
- `<leader>ll` - Open logbook
- `<leader>lt` - Insert timestamp

## License

MIT
