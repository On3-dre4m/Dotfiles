vim.pack.add({ { src = "https://github.com/hedyhli/outline.nvim", name = "outline" } })
-- "hedyhli/outline.nvim",
require("outline").setup({
	-- Your setup opts here (leave empty to use defaults)
	providers = {
		priority = { "markdown", "lsp", "man" },
		lsp = {
			blacklist_clients = { "markdown_oxide" },
		},
		markdown = {
			filetypes = { "markdown" },
		},
	},
})

-- Example mapping to toggle outline
vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
