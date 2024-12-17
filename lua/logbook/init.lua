local config = require("logbook.config")
local utils = require("logbook.utils")

local M = {}

function M.setup(opts)
	-- Set up configuration
	config.setup(opts)

	-- Create commands
	vim.api.nvim_create_user_command("LogbookOpen", function(cmd_opts)
		utils.open_logbook(cmd_opts.args)
	end, {
		nargs = "?",
		complete = utils.complete_logbook_files,
	})

	vim.api.nvim_create_user_command("LogbookInsertTimestamp", function()
		utils.insert_timestamp()
	end, {})

	-- Add new QuickLogbook command
	vim.api.nvim_create_user_command("QuickLogbook", function()
		utils.quick_logbook()
	end, {})

	-- Set up default keymaps if enabled
	if config.options.use_default_keymaps then
		vim.keymap.set("n", "<leader>ll", ":LogbookOpen<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>lt", ":LogbookInsertTimestamp<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>lq", ":QuickLogbook<CR>", { noremap = true, silent = true })
	end
end

return M
