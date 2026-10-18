vim.pack.add({ { src = "https://github.com/lewis6991/gitsigns.nvim", name = "gitsigns", version = "v2.1.0" } })
-- 		"lewis6991/gitsigns.nvim",
require("gitsigns").setup({
	-- See `:help gitsigns.txt`
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},

	signs_staged = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},

	current_line_blame = true,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
		virt_text_priority = 100,
		use_focus = true,
	},

	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")
		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]h", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]h", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end)

		map("n", "[h", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[h", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)

		-- Actions
		map("n", "<leader>gs", gitsigns.stage_hunk, { silent = true, desc = "Gitsigns [S]tage Hunk" })
		map("n", "<leader>grr", gitsigns.reset_hunk, { silent = true, desc = " Gitsigns [R]eset Hunk" })

		map("v", "<leader>gs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }, { silent = true, desc = "Gitsigns [S]tage Hunk" })
		end)

		map("v", "<leader>grr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }, { silent = true, desc = " Gitsigns [R]eset Hunk" })
		end)

		map("n", "<leader>gS", gitsigns.stage_buffer, { silent = true, desc = "Gitsigns [S]tage BUFFER" })
		map("n", "<leader>gR", gitsigns.reset_buffer, { silent = true, desc = "Gitsigns [R]eset BUFFER" })
		map("n", "<leader>gp", gitsigns.preview_hunk, { silent = true, desc = "Gitsigns [P]review HUNK" })
		map("n", "<leader>gi", gitsigns.preview_hunk_inline, { silent = true, desc = "Gitsigns [P]review inline HUNK" })

		-- Toggles
		map("n", "<leader>gtd", gitsigns.toggle_deleted, { silent = true, desc = "Gitsigns [T]oggle Deleted" })
		map("n", "<leader>gtl", gitsigns.toggle_linehl, { silent = true, desc = "Gitsigns [T]oggle Line" })
		map("n", "<leader>gtw", gitsigns.toggle_word_diff, { silent = true, desc = "Gitsigns [T]oggle Word Diff" })
		map("n", "<leader>gts", gitsigns.toggle_signs, { silent = true, desc = "Gitsigns [T]oggle Word Diff" })
	end,
})
