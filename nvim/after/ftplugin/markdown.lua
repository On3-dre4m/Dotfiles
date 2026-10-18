local set = vim.opt_local

set.textwidth = 80
set.spell = false
set.linebreak = true
set.wrap = true
set.formatoptions:append("t")

set.foldexpr = "v:lua.vim.treesitter.foldexpr()"
set.foldmethod = "expr"

set.isfname:append("32")
set.suffixesadd:append(".png")
set.suffixesadd:append(".jpg")
set.suffixesadd:append(".webp")

vim.keymap.set("n", "<leader>pt", ':set paste<CR>"+p:set nopaste<CR>gqap', {
	buffer = true,
	noremap = true,
	silent = true,
	desc = "Paste and format to textwidth",
})

vim.keymap.set("v", "<C-b>", 'c**<C-r>"**<Esc>', { silent = true })
vim.keymap.set("v", "<C-n>", 'c`<C-r>"`<Esc>', { silent = true })
vim.keymap.set("v", "<C-h>", 'c_<C-r>"_<Esc>', { silent = true })
vim.wo.colorcolumn = "90"

-- Colorscheme
vim.api.nvim_set_hl(0, "winseparator", { fg = "#7700c7", bg = "none" })
vim.api.nvim_set_hl(0, "@markup.strong.markdown_inline", { fg = "#e04f4f", bg = "none", bold = true })
vim.api.nvim_set_hl(0, "@markup.italic.markdown_inline", { fg = "#fa9804", bg = "#26250d", bold = true, italic = true })
vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { fg = "#06ff06", bg = "none", bold = true, italic = true })
vim.api.nvim_set_hl(0, "@markup.raw.block.markdown", { fg = "#06ff06", bg = "none", bold = true, italic = true })

vim.api.nvim_set_hl(0, "@markup.quote.markdown", { fg = "#ffffff", bg = "#171716", bold = true, italic = true })

vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { fg = "#06388D", bg = "#AFAFAF", bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { fg = "#005EFF", bg = "#000002", bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { fg = "#6297F2", bg = "#000003", bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { fg = "#B7CCEF", bg = "#000004", bold = true })

-- vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { fg = "#FF04CE", bg = "#000001", bold = true })
-- vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { fg = "#8814FD", bg = "#000002", bold = true })
-- vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { fg = "#A059F0", bg = "#000003", bold = true })
-- vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { fg = "#B495D7", bg = "#000004", bold = true })

-- _G.custom_path_complete = function(findstart, base)
-- 	if findstart == 1 then
-- 		local line = vim.api.nvim_get_current_line()
-- 		local col = vim.api.nvim_win_get_cursor(0)[2]
-- 		local line_to_cursor = line:sub(1, col)
-- 		return vim.fn.matchstrpos(line_to_cursor, [[\k*$]])[2]
-- 	else
-- 		local search_paths = { "/mnt/E_Drive/Workplace/Obsidian/Vault" }
-- 		local matches = {}
--
-- 		for _, path in ipairs(search_paths) do
-- 			local files = vim.fn.globpath(path, base .. "*", 0, 1)
-- 			for _, file in ipairs(files) do
-- 				local filename = vim.fn.fnamemodify(file, ":t:r")
--
-- 				table.insert(matches, {
-- 					word = filename,
-- 					abbr = filename,
-- 					menu = "[FILE]",
-- 					icase = 1,
-- 				})
-- 			end
-- 		end
-- 		return matches
-- 	end
-- end
--
-- vim.opt.omnifunc = "v:lua.custom_path_complete"

-- Customize |gx| behavior
local function smart_gx()
	-- 1. Get file path under cursor
	local file = vim.fn.expand("<cfile>")

	-- 2. Search for file with |path| and |suffixesadd| options
	local found_file = vim.fn.findfile(file)

	-- 3.
	if found_file ~= "" then
		-- Convert to absolute path so that OS isn't confused
		local full_path = vim.fn.fnamemodify(found_file, ":p")
		vim.fn.jobstart({ "xdg-open", full_path })
	else
		vim.notify("File under cursor not been found", vim.log.levels.WARN)
	end
end

vim.keymap.set("n", "gx", smart_gx)

-- Customize |gf|

local function smart_gf()
	-- 1. Get the path under the cursor
	local file = vim.fn.expand("<cfile>")

	-- 2. Decode '%20' into a space
	file = file:gsub("%%20", " ")

	-- x.
	local current_file_dir = vim.fn.expand("%:p:h")
	local root = vim.fs.root(current_file_dir, { ".git", ".obsidian" })

	local ok, err = pcall(vim.cmd, "edit " .. vim.fn.fnameescape(file))
	if not ok then
		vim.notify("Could not open file: " .. file, vim.log.levels.ERROR)
	end
end

vim.keymap.set("n", "gf", smart_gf)

-------------------------
-- Copy codeblock Utility
-------------------------

local function CopyCodeBlock()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local row = vim.api.nvim_win_get_cursor(0)[1]

	local start_line, end_line

	-- Find the opening fence above the cursor
	for i = row, 1, -1 do
		if lines[i]:match("^%s*```") then
			start_line = i
			break
		end
	end

	if not start_line then
		vim.notify("No code block found", vim.log.levels.WARN)
		return
	end

	-- Find the closing fence
	for i = start_line + 1, #lines do
		if lines[i]:match("^%s*```%s*$") then
			end_line = i
			break
		end
	end

	if not end_line or row <= start_line or row >= end_line then
		vim.notify("Cursor is not inside a code block", vim.log.levels.WARN)
		return
	end

	local code = vim.list_slice(lines, start_line + 1, end_line - 1)

	vim.fn.setreg("+", table.concat(code, "\n"))
	vim.notify("Code block copied to clipboard")
end

vim.api.nvim_create_user_command("CopyCodeBlock", function()
	CopyCodeBlock()
end, {})
