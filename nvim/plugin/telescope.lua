-- vim.pack.add({ { src = "https://github.com/nvim-telescope/telescope.nvim", name = "telescope" } })
-- "nvim-telescope/telescope.nvim",
-- dependencies = {
-- 	"nvim-lua/plenary.nvim",
-- 	"sharkdp/fd",
-- },
-- local builtin = require("telescope.builtin")
-- vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [G]rep" })
-- vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [T]ags" })
-- vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffer" })
-- vim.keymap.set("n", "<leader>fc", builtin.colorscheme, { desc = "[F]ind [C]olorscheme" })
--
-- vim.keymap.set("n", "<leader>fs", builtin.treesitter, { desc = "[F]ind Symbols in TREESITTER" })
-- vim.keymap.set("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "[F]ind [S]ymbols" })
-- vim.keymap.set("n", "<leader>fi", builtin.lsp_incoming_calls, { desc = "[F]ind [I]ncoming Calls" })
-- vim.keymap.set("n", "<leader>fI", builtin.builtin, { desc = "[F]ind [A]ll Builtin Functions" })
-- vim.keymap.set("n", "<leader>fn", ":Noice telescope<CR>", { desc = "[F]ind [N]oice history" })

-- Slightly advanced example of overriding default behavior and theme
-- vim.keymap.set("n", "<leader>/", function()
-- 	-- You can pass additional configuration to Telescope to change the theme, layout, etc.
-- 	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
-- 		winblend = 30,
-- 		previewer = true,
-- 	}))
-- end, { desc = "[/] Fuzzily search in current buffer" })
--
-- require("telescope").setup({
-- 	defaults = {},
-- 	extensions = {},
-- })

vim.pack.add({ { src = "https://github.com/folke/snacks.nvim", name = "snacks", version = "v2.31.0" } })
require("snacks").setup({
	styles = {
		snacks_image = {
			relative = "editor", -- position relative to the whole editor
			border = "rounded",
			focusable = false,
			backdrop = false,
			row = 1, -- distance from top
			col = vim.o.columns, -- dynamically push to the right (40 cols from right edge)
			zindex = 100, -- ensure it's on top
			-- optionally fix width/height if you want uniform sizing
			wo = {
				winhighlight = "NormalFloat:Normal",
			},
		},
		zen = {
			enter = true,
			fixbuf = false,
			minimal = false,
			width = 150,
			height = 0,
			backdrop = { transparent = false, blend = 150 },
			keys = { q = false },
			zindex = 40,
			wo = {
				winhighlight = "NormalFloat:Normal",
			},
			w = {
				snacks_main = true,
			},
		},
	},

	bigfile = { enabled = true },

	explorer = {
		enabled = true,
		replace_netrw = true,
		win = {
			list = {
				keys = {
					["Esc"] = "close",
				},
			},
		},
	},

	zen = {
		enabled = true,
	},

	image = {
		enabled = true,
		doc = {
			inline = false,
			float = true,
			-- inline = true,
			-- float = false,
			max_width = 120,
			max_height = 60,
			conceal = function(lang, type)
				-- only conceal math expressions
				return not type == "math"
			end,
		},
		convert = {
			notify = false,
		},
		---@class snacks.image.convert.Config
		math = {
			enabled = true,
			latex = {
				font_size = "Large", -- see https://www.sascha-frank.com/latex-font-size.html
				-- for latex documents, the doc packages are included automatically,
				-- but you can add more packages here. Useful for markdown documents.
				packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools" },
				tpl = [[
                    \documentclass[preview,border=0pt,varwidth=20cm,12pt]{standalone}
                    \usepackage{${packages}}
                    \setlength{\jot}{10pt}
                    \begin{document}
                    { \${font_size} \selectfont
                      \color[HTML]{${color}}
                    ${content}}
                    \end{document}]],
			},
		},
	},

	picker = {
		enabled = true,
		win = {
			input = {
				keys = {
					["<Esc>"] = { "close", mode = { "n", "i" } },
					["J"] = { "preview_scroll_down", mode = { "i", "n" } },
					["K"] = { "preview_scroll_up", mode = { "i", "n" } },
					["?"] = { "toggle_help_input", mode = "i" },
				},
			},
		},
	},
})

-- File Explorer
-- vim.keymap.set("n", "<leader>w", function()
-- 	Snacks.explorer()
-- end, { desc = "File Explorer" })

-- Find Colorschemes
vim.keymap.set("n", "<leader>fc", function()
	Snacks.picker.colorschemes({
		finder = "vim_colorschemes",
		format = "text",
		preview = "colorscheme",
		preset = "vertical",
		confirm = function(picker, item)
			picker:close()
			if item then
				picker.preview.state.colorscheme = nil
				vim.schedule(function()
					vim.cmd("colorscheme " .. item.text)
				end)
			end
		end,
	})
end, { desc = "[F]ind [C]olorschemes" })

-- Find Buffers
vim.keymap.set("n", "<leader>fb", function()
	Snacks.picker.buffers({
		finder = "buffers",
		format = "buffer",
		hidden = false,
		unloaded = true,
		current = true,
		sort_lastused = true,
		win = {
			input = {
				keys = {
					["<c-x>"] = { "bufdelete", mode = { "n", "i" } },
				},
			},
			list = { keys = { ["D"] = "bufdelete" } },
		},
		layout = { preset = "vscode" },
	})
end, { desc = "[F]ind [B]uffers" })

-- Find Files
vim.keymap.set("n", "<leader>ff", function()
	Snacks.picker.files({
		finder = "files",
		format = "file",
		show_empty = true,
		hidden = true,
		ignored = true,
		follow = false,
		supports_live = true,
		layout = { preset = "vscode" },
	})
end, { desc = "[F]ind [F]iles" })

-- Find Grep
vim.keymap.set("n", "<leader>fg", function()
	Snacks.picker.grep({
		finder = "grep",
		regex = true,
		format = "file",
		show_empty = true,
		live = true,
		supports_live = true,
	})
end, { desc = "[F]ind [G]rep" })

-- Find Marks
vim.keymap.set("n", "<leader>fm", function()
	Snacks.picker.marks({
		finder = "vim_marks",
		format = "file",
		global = true,
		["local"] = true,
	})
end, { desc = "[F]ind [M]arks" })

-- Find Registers
vim.keymap.set("n", "<leader>fr", function()
	Snacks.picker.registers({
		finder = "vim_registers",
		format = "register",
		preview = "preview",
		confirm = { "copy", "close" },
		layout = { preset = "vscode" },
	})
end, { desc = "[F]ind [R]egisters" })

-- Find LSP Symbols
vim.keymap.set("n", "<leader>fs", function()
	Snacks.picker.lsp_symbols({
		finder = "lsp_symbols",
		format = "lsp_symbol",
		tree = true,
	})
end, { desc = "[F]ind [S]ymbols" })

-- Find Workspace Symbols
vim.keymap.set("n", "<leader>fS", function()
	Snacks.picker.lsp_workspace_symbols()
end, { desc = "[F]ind Workspace [S]ymbols" })

-- Find Snacks Built-in Pickers
vim.keymap.set("n", "<leader>fI", function()
	Snacks.picker.pickers({
		finder = "meta_pickers",
		format = "text",
		confirm = function(picker, item)
			picker:close()
			if item then
				vim.schedule(function()
					Snacks.picker(item.text)
				end)
			end
		end,
	})
end, { desc = "[F]ind SNACKS.PICKER built-in func" })
