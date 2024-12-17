-- lua/logbook/utils.lua
local config = require("logbook.config")

local M = {}

function M.open_logbook(name)
	-- Store current working directory
	local current_dir = vim.fn.getcwd()

	local filename
	if name and name ~= "" then
		filename = config.options.default_path .. "/" .. name .. config.options.file_extension
	else
		filename = config.options.default_path .. "/" .. os.date("%Y-%m-%d") .. config.options.file_extension
	end

	-- Create file if it doesn't exist
	if vim.fn.filereadable(filename) == 0 then
		-- Temporarily change directory to create the file
		vim.cmd("lcd " .. vim.fn.fnameescape(config.options.default_path))
		local file = io.open(filename, "w")
		if file then
			if config.options.template then
				file:write(config.options.template)
			else
				file:write("# Logbook: " .. vim.fn.fnamemodify(filename, ":t:r") .. "\n\n")
			end
			file:close()
		end
		-- Return to original directory
		vim.cmd("lcd " .. vim.fn.fnameescape(current_dir))
	end

	-- Store current position in both jumplist and tagstack
	vim.cmd("normal! m'")

	-- Emulate tag behavior by pushing to the tag stack
	local from_pos = vim.fn.getpos(".")
	vim.fn.settagstack(vim.fn.win_getid(), {
		items = {
			{
				bufnr = vim.fn.bufnr("%"),
				from = { from_pos[1], from_pos[2], from_pos[3] },
				tagname = "logbook_" .. os.date("%Y%m%d_%H%M%S"),
			},
		},
		type = "push",
	})

	-- Open the file in a buffer using full path
	vim.cmd("edit " .. vim.fn.fnameescape(filename))

	-- Ensure we're back in the original directory
	vim.cmd("lcd " .. vim.fn.fnameescape(current_dir))
end

function M.insert_timestamp()
	local timestamp = os.date(config.options.date_format)
	local pos = vim.api.nvim_win_get_cursor(0)
	local line = vim.api.nvim_get_current_line()
	local new_line = line:sub(1, pos[2]) .. timestamp .. line:sub(pos[2] + 1)
	vim.api.nvim_set_current_line(new_line)
	vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + #timestamp })
end

function M.complete_logbook_files()
	return vim.fn.glob(config.options.default_path .. "/*" .. config.options.file_extension, false, true)
end

return M
