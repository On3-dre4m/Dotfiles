vim.keymap.set("n", "<leader>cs", function()
	vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#808080", bold = true })
	vim.api.nvim_set_hl(0, "LineNr", { fg = "#ffffff", bg = "#616360" }) -- Highlight other line numbers
	vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#808080", bold = true })
	vim.api.nvim_set_hl(0, "@markup.raw.block.markdown", { bg = "#000000" })
end, { desc = "Highlight current cursor" })

--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- Resize with arrows
-- vim.keymap.set("n", "<Up>", ":resize -6<CR>", {})
-- vim.keymap.set("n", "<Down>", ":resize +6<CR>", {})
-- vim.keymap.set("n", "<Left>", ":vertical resize -6<CR>", {})
-- vim.keymap.set("n", "<Right>", ":vertical resize +6<CR>", {})

-- Save file
vim.keymap.set("n", "<C-s>", "<cmd> silent w <CR>", {})

-- Quit file
vim.keymap.set("n", "<C-q>", "<cmd> q <CR>", {})

-- Delete single character without copying into register
vim.keymap.set("n", "x", '"_x', {})

-- Tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", {}) -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", {}) -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", {}) -- close current tab

-- Buffers
vim.keymap.set("n", "<leader>bb", "<C-^>", { desc = "Switch to alternate buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd> bd <cr>", { desc = "Delete current buffer" })
vim.keymap.set("n", "<leader>bn", ":bnext<cr>", { desc = "Switch to alternate buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<cr>", { desc = "Switch to alternate buffer" })

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v<C-w><C-l>", {}) -- split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s<C-w><C-j>", {}) -- split window horizontally

vim.keymap.set("n", "<leader>cc", "<cmd>bdelete<CR>", { silent = true, desc = "[C]lose [C]urrent Buffer Line" })

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", {})
vim.keymap.set("v", ">", ">gv", {})

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', {})

-- Yank to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })

-- Language Server Protocol (LSP) keymaps
vim.keymap.set("n", "K", function()
	vim.lsp.buf.hover({ border = "single" })
end, { desc = "Hover documentation" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true, desc = "[G]oto [D]efinition" })
vim.keymap.set("n", "<leader>D", vim.diagnostic.open_float, { silent = true, desc = "[D]iagnostic float window" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "show [C]ode [A]ction" })
-- vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "show [G]oto [R]eference" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "show [R]ename options" })

---
---

-- Define the function to handle the logic
local function smart_semicolon_newline()
	local ft = vim.bo.filetype
	-- Save cursor position
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()

	if ft == "c" or ft == "cpp" then
		-- Add semicolon at end if not already present
		if not line:match(";%s*$") then
			line = line:gsub("%s*$", "") .. ";"

			-- Update line and move to new line
			vim.api.nvim_set_current_line(line)
		end

		vim.api.nvim_win_set_cursor(0, { row, #line + 1 })

		-- Check the current mode
		local mode_info = vim.api.nvim_get_mode()
		local current_mode = mode_info.mode

		if current_mode == "n" then
			vim.api.nvim_command("startinsert")
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, false, true), "n", true)
		end
		vim.api.nvim_feedkeys("\n", "n", false)
	end
end

-- Set the keymap for normal and insert mode
vim.keymap.set({ "n", "i" }, "<C-n>", smart_semicolon_newline, { noremap = true, silent = true })

-- Add custom behavior for Tab to exit pairs
vim.keymap.set("i", "<Tab>", function()
	local col = vim.fn.col(".")
	local line = vim.fn.getline(".")
	local char = line:sub(col, col)

	-- Define the characters to jump out of
	local closers = { "(", ")", "[", "]", "{", "}", "'", '"', "`", "<", ">", ";", ",", "$" }

	-- If cursor is on a closing character, move it one step to the right
	if vim.tbl_contains(closers, char) then
		return "<Right>"
	else
		-- Otherwise, insert a Tab
		return "<Tab>"
	end
end, { expr = true, noremap = true })
