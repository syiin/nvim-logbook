-- lua/logbook/utils.lua
local config = require("logbook.config")

local M = {}

function M.open_logbook(name)
	local filename
	if name and name ~= "" then
		filename = config.options.default_path .. "/" .. name .. config.options.file_extension
	else
		filename = config.options.default_path .. "/" .. os.date("%Y-%m-%d") .. config.options.file_extension
	end

	-- Create file if it doesn't exist
	if vim.fn.filereadable(filename) == 0 then
		local file = io.open(filename, "w")
		if file then
			if config.options.template then
				file:write(config.options.template)
			else
				file:write("# Logbook: " .. vim.fn.fnamemodify(filename, ":t:r") .. "\n\n")
			end
			file:close()
		end
	end

	vim.cmd("edit " .. vim.fn.fnameescape(filename))
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
