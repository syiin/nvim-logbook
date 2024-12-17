-- lua/logbook/config.lua
local M = {}

M.defaults = {
	default_path = vim.fn.expand("~/logbook"),
	date_format = "%Y-%m-%d %H:%M:%S",
	file_extension = ".md",
	use_default_keymaps = true,
	template = nil, -- Optional template for new files
}

M.options = {}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

	-- Create default directory if it doesn't exist
	if vim.fn.isdirectory(M.options.default_path) == 0 then
		vim.fn.mkdir(M.options.default_path, "p")
	end
end

return M
