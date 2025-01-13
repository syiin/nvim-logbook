local config = require("logbook.config")

local M = {}

-- Helper function to get current ISO week number and year
local function get_current_week()
	return os.date(config.options.weekly_format)
end

-- Helper function to create file with template
local function create_file_with_template(filename, mode, date_str)
	local file = io.open(filename, "w")
	if file then
		local template = config.options.templates[mode]
		if template then
			if date_str then
				file:write(string.format(template, date_str))
			else
				file:write(template)
			end
		end
		file:close()
	end
end

function M.quick_logbook(name, mode)
	-- Store current working directory
	local current_dir = vim.fn.getcwd()
	mode = mode or config.options.mode

	local filename
	if mode == "scratchpad" then
		filename = config.options.default_path .. "/" .. config.options.scratchpad_name .. config.options.file_extension
	elseif mode == "weekly" then
		local week = get_current_week()
		filename = config.options.default_path .. "/" .. week .. config.options.file_extension
	else -- daily mode
		if name and name ~= "" then
			filename = config.options.default_path .. "/" .. name .. config.options.file_extension
		else
			filename = config.options.default_path .. "/" .. os.date("%Y-%m-%d") .. config.options.file_extension
		end
	end

	-- Create file if it doesn't exist
	if vim.fn.filereadable(filename) == 0 then
		-- Temporarily change directory to create the file
		vim.cmd("lcd " .. vim.fn.fnameescape(config.options.default_path))

		local date_str
		if mode == "daily" then
			date_str = os.date("%Y-%m-%d")
		elseif mode == "weekly" then
			date_str = get_current_week()
		end

		create_file_with_template(filename, mode, date_str)
	end

	-- Add current position to jumplist before moving
	vim.cmd("normal! m'")

	-- Open the file in a buffer using full path
	vim.cmd("edit " .. vim.fn.fnameescape(filename))

	-- Return to original directory at window level
	vim.cmd("lcd " .. vim.fn.fnameescape(current_dir))
end

function M.open_logbook()
	-- Store current working directory for jumplist
	local current_dir = vim.fn.getcwd()

	-- Add current position to jumplist
	vim.cmd("normal! m'")

	local filename, date_str
	if config.options.mode == "scratchpad" then
		filename = config.options.scratchpad_name .. config.options.file_extension
		date_str = nil
	elseif config.options.mode == "weekly" then
		date_str = get_current_week()
		filename = date_str .. config.options.file_extension
	else -- daily mode
		date_str = os.date("%Y-%m-%d")
		filename = date_str .. config.options.file_extension
	end

	local full_path = config.options.default_path .. "/" .. filename

	-- Create file if it doesn't exist
	if vim.fn.filereadable(full_path) == 0 then
		-- Ensure directory exists
		if vim.fn.isdirectory(config.options.default_path) == 0 then
			vim.fn.mkdir(config.options.default_path, "p")
		end

		create_file_with_template(full_path, config.options.mode, date_str)
	end

	-- Open the file
	vim.cmd("edit " .. vim.fn.fnameescape(full_path))

	-- Set the buffer's working directory to the logbook directory
	vim.cmd("lcd " .. vim.fn.fnameescape(config.options.default_path))
end

-- Other existing functions remain the same
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
