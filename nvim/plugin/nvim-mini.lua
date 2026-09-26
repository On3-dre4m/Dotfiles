vim.pack.add({ { src = "https://github.com/nvim-mini/mini.nvim", name = "mini" } })
-- "nvim-mini/mini.nvim",
require("mini.ai").setup({})
require("mini.surround").setup({
	n_lines = 9999,
})
require("mini.files").setup({})
vim.keymap.set("n", "<leader>w", function()
	MiniFiles.open()
end, { desc = "MiniFiles" })

-- NOTE: Appearance
require("mini.notify").setup({
	-- Content management
	content = {
		-- Function which formats the notification message
		-- By default prepends message with notification time
		format = nil,
		-- Function which orders notification array from most to least important
		-- By default orders first by level and then by update timestamp
		sort = nil,
	},

	-- Notifications about LSP progress
	lsp_progress = {
		-- Whether to enable showing
		enable = false,
		level = "ERROR",
		-- Duration (in ms) of how long last message should be shown
		duration_last = 1000,
	},

	-- Window options
	window = {
		-- Floating window config
		config = {},
		-- Value of 'winblend' option
		winblend = 25,
	},
})

vim.notify = require("mini.notify").make_notify({
	ERROR = { duration = 8000 },
	WARN = { duration = 8000 },
	INFO = { duration = 8000 },
	DEBUG = { duration = 8000 },
})

vim.keymap.set("n", "<leader>fn", function()
	MiniNotify.show_history()
end, { desc = "Show all messages" })
