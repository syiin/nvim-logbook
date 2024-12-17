local M = {}

-- Helper function to safely expand and normalize paths
local function normalize_path(path)
	-- If path starts with ~, expand it
	if path:match("^~") then
		path = vim.fn.expand(path)
	end

	-- Remove any trailing slashes
	path = path:gsub("/$", "")

	-- Convert to absolute path
	if not path:match("^/") then
		path = vim.fn.fnamemodify(path, ":p")
	end

	return path
end

M.defaults = {
	default_path = normalize_path("~/logbook"),
	date_format = "%Y-%m-%d %H:%M:%S",
	file_extension = ".md",
	use_default_keymaps = true,
	template = nil,
}

M.options = {}

function M.setup(opts)
	-- If user provides a path, normalize it
	if opts and opts.default_path then
		opts.default_path = normalize_path(opts.default_path)
	end

	M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

	-- Create default directory if it doesn't exist
	if vim.fn.isdirectory(M.options.default_path) == 0 then
		local success, err = pcall(vim.fn.mkdir, M.options.default_path, "p")
		if not success then
			vim.notify("Failed to create logbook directory: " .. err, vim.log.levels.ERROR)
		end
	end
end

return M
