vim.pack.add({ { src = "https://github.com/mason-org/mason.nvim", name = "mason" } })
vim.pack.add({ { src = "https://github.com/mason-org/mason-lspconfig.nvim", name = "mason-lspconfig" } })
require("mason").setup()
require("mason-lspconfig").setup()

vim.pack.add({ { src = "https://github.com/neovim/nvim-lspconfig" } })
-- "neovim/nvim-lspconfig",
-- "barreiroleo/ltex_extra.nvim",
-- "saghen/blink.cmp",

local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("*", { capabilities = capabilities }) -- Enable `blink.cmp` AutoCompletion

-- Where to add LSP for Language
-- To avoid false recognizing LSP instead of formatter/linter
vim.lsp.enable("stylua", false)
vim.lsp.enable("harper_ls", false)
vim.lsp.enable("ruff", false)

vim.lsp.enable("lua_ls")
-- vim.lsp.enable("clangd")
vim.lsp.enable("ty")
-- vim.lsp.enable("texlab")
-- vim.lsp.enable("markdown_oxide")
