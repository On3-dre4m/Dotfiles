vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })

require("catppuccin").setup({
	flavor = "mocha",
	-- transparent_background = true,
	integrations = {
		gitsigns = true,
		flash = true,
		blink_cmp = true,
	},
	highlight_overrides = {
		all = function(colors)
			return {
				LineNrAbove = { fg = "#808080" },
				CursorLineNr = { fg = "#17fff7" },
				LineNrBelow = { fg = "#808080" },
				ColorColumn = { bg = "#6F4B72" }, -- Highlight the color column
			}
		end,
	},
})
vim.cmd.colorscheme("catppuccin-nvim")

-- Delay applying highlights slightly to ensure they take effect
vim.keymap.set("n", "<leader>T", function()
	local cat = require("catppuccin")
	cat.options.transparent_background = not cat.options.transparent_background
	cat.compile()
	vim.cmd.colorscheme(vim.g.colors_name)
end)
