vim.api.nvim_create_autocmd("FileType", {
	pattern = { "tex", "plaintex", "latex" }, -- Cover all possible LaTeX filetypes
	callback = function()
		vim.bo.textwidth = 80

		vim.wo.wrap = true
		vim.wo.linebreak = true

		vim.opt.breakat = " ;:,!?"
		vim.opt.display = "lastline"
		vim.notify("LaTeX settings applied for filetype: " .. vim.bo.filetype, vim.log.levels.INFO)
	end,
	desc = "Set LaTeX-specific buffer settings",
})

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = { "markdown" }, --Cover all possible Markdown filetypes
-- 	callback = function()
-- 		vim.opt_local.conceallevel = 0
-- 	end,
-- })
