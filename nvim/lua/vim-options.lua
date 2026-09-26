----------------------
-- GENERAL SETTINGS --
----------------------
vim.cmd("set encoding=utf-8")
vim.cmd("set fileencoding=utf-8")
vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.opt.modeline = false
vim.opt.modelines = 0

vim.diagnostic.config({ virtual_lines = { current_line = true }, float = { border = "rounded" } })
vim.g.lazy_timeout = 0

-------------------------------
-- NATIVE COMPLETION/SNIPPET --
-------------------------------
-- Reference: <https://youtu.be/s7zb73fgXqU?si=l82nkYrhZYSh2MHm>
-- vim.o.autocomplete = true
-- vim.opt.complete:append("o")
vim.opt.completeopt = "fuzzy,menuone,noselect,popup"
-- vim.o.pumheight = 10
-- vim.o.pumborder = "rounded"
--
-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	callback = function(ev)
-- 		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
--
-- 		if client:supports_method("textDocument/completion") then
-- 			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
-- 		end
-- 	end,
-- })

---------------------
-- INDENT SETTINGS --
---------------------
vim.opt.tabstop = 4 -- insert n spaces for a tab
vim.opt.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.opt.softtabstop = 4 -- number of spaces that a tab counts for while performing editing operations
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.smartindent = true -- make indenting smarter again
vim.opt.autoindent = true -- copy indent from current line when starting new one (default: true)
vim.opt.breakindent = true -- enable break indent (default: false)

vim.opt.numberwidth = 4 -- set number column width to 2 {default 4}
vim.opt.ignorecase = true -- case-insensitive searching unless \c or capital in search (default: false)
vim.opt.laststatus = 3
vim.opt.smartcase = true -- smart case (default: false)

-------------------
-- FILE HANDLING --
-------------------
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false -- creates a swapfile
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.autoread = true
vim.opt.autowrite = false

vim.cmd("set path+=**")
vim.cmd("set isfname+=32")
vim.cmd("set suffixesadd+=.md")

-------------
-- FOLDING --
-------------
vim.opt.foldcolumn = "0" -- turn off show column
vim.opt.foldtext = ""
vim.opt.foldenable = true -- keep folds closed by default
vim.opt.foldlevel = 99 -- open all folds by default
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 5

---------
-- GUI --
---------
vim.opt.guicursor = {
	"n-v-c:block", -- normal, visual, command mode: block cursor
	"i:ver50-blinkon250-blinkoff250", -- insert mode: vertical bar, blinking
	"r-cr:hor20", -- replace mode: horizontal bar
	"o:hor50", -- operator-pending mode
}
vim.opt.termguicolors = true
vim.api.nvim_set_hl(0, "floatborder", { fg = "#ffffff" })
