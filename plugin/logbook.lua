-- ~/.config/nvim/lua/plugins/logbook.lua
return {
  'syiin/nvim-logbook', -- replace with your preferred plugin name
  lazy = false,
  config = function()
    local logbook = {}

    -- Configuration with defaults
    logbook.config = {
      default_path = vim.fn.expand '~/logbook',
      date_format = '%Y-%m-%d %H:%M:%S',
      file_extension = '.md',
    }

    -- Function to open or create a logbook file
    local function open_logbook(name)
      local filename
      if name and name ~= '' then
        filename = logbook.config.default_path .. '/' .. name .. logbook.config.file_extension
      else
        -- Use today's date as filename if none specified
        filename = logbook.config.default_path .. '/' .. os.date '%Y-%m-%d' .. logbook.config.file_extension
      end

      -- Create file if it doesn't exist
      if vim.fn.filereadable(filename) == 0 then
        local file = io.open(filename, 'w')
        if file then
          file:write('# Logbook: ' .. vim.fn.fnamemodify(filename, ':t:r') .. '\n\n')
          file:close()
        end
      end

      -- Open the file
      vim.cmd('edit ' .. vim.fn.fnameescape(filename))
    end

    -- Function to insert timestamp at cursor position
    local function insert_timestamp()
      local timestamp = os.date(logbook.config.date_format)
      local pos = vim.api.nvim_win_get_cursor(0)
      local line = vim.api.nvim_get_current_line()
      local new_line = line:sub(1, pos[2]) .. timestamp .. line:sub(pos[2] + 1)
      vim.api.nvim_set_current_line(new_line)
      vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + #timestamp })
    end

    -- Create default directory if it doesn't exist
    if vim.fn.isdirectory(logbook.config.default_path) == 0 then
      vim.fn.mkdir(logbook.config.default_path, 'p')
    end

    -- Create user commands
    vim.api.nvim_create_user_command('LogbookOpen', function(opts)
      open_logbook(opts.args)
    end, {
      nargs = '?',
      complete = function()
        return vim.fn.glob(logbook.config.default_path .. '/*' .. logbook.config.file_extension, false, true)
      end,
    })

    vim.api.nvim_create_user_command('LogbookInsertTimestamp', function()
      insert_timestamp()
    end, {})

    -- Set up key mappings
    vim.keymap.set('n', '<leader>ll', ':LogbookOpen<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>lt', ':LogbookInsertTimestamp<CR>', { noremap = true, silent = true })
  end,
  opts = {
    -- Optional: override defaults here
    -- default_path = '~/documents/logbook',
    -- date_format = '%Y-%m-%d %H:%M:%S',
    -- file_extension = '.md'
  },
}
