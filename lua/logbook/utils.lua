local config = require("logbook.config")

local M = {}

function M.quick_logbook(name)
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
	end

	-- Add current position to jumplist before moving
	vim.cmd("normal! m'")

	-- Open the file in a buffer using full path
	vim.cmd("edit " .. vim.fn.fnameescape(filename))

	-- Return to original directory at window level
	vim.cmd("lcd " .. vim.fn.fnameescape(current_dir))
end

-- New function to open current day's logbook and set its directory
function M.open_logbook()
	-- Store current working directory for jumplist
	local current_dir = vim.fn.getcwd()

	-- Add current position to jumplist
	vim.cmd("normal! m'")

	-- Construct today's filename
	local filename = os.date("%Y-%m-%d") .. config.options.file_extension
	local full_path = config.options.default_path .. "/" .. filename

	-- Create file if it doesn't exist
	if vim.fn.filereadable(full_path) == 0 then
		-- Ensure directory exists
		if vim.fn.isdirectory(config.options.default_path) == 0 then
			vim.fn.mkdir(config.options.default_path, "p")
		end

		local file = io.open(full_path, "w")
		if file then
			if config.options.template then
				file:write(config.options.template)
			else
				file:write("# Logbook: " .. os.date("%Y-%m-%d") .. "\n\n")
			end
			file:close()
		end
	end

	-- Open the file
	vim.cmd("edit " .. vim.fn.fnameescape(full_path))

	-- Set the buffer's working directory to the logbook directory
	vim.cmd("lcd " .. vim.fn.fnameescape(config.options.default_path))
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
