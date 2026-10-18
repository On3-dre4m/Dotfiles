vim.pack.add({ { src = "https://github.com/L3MON4D3/LuaSnip", name = "luasnip" } })
vim.pack.add({ { src = "https://github.com/rafamadriz/friendly-snippets" } })
-- "L3MON4D3/LuaSnip"
-- "rafamadriz/friendly-snippets"
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").load({ paths = "./snippets" })
-- Also include latex snippets to markdown filetype
require("luasnip").filetype_extend("markdown", { "tex" })

--
--

vim.pack.add({ { src = "https://github.com/Saghen/blink.cmp", name = "blink.cmp", version = "v1.10.2" } })
vim.pack.add({ { src = "https://github.com/nvim-lua/plenary.nvim", name = "plenary" } })
-- "saghen/blink.cmp",
-- dependencies = {
-- 	"rafamadriz/friendly-snippets"
-- 	"nvim-lua/plenary.nvim"
-- },
-- event = { "BufReadPre", "BufNewFile" },
require("blink.cmp").setup({
	keymap = {
		preset = "default",
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide", "fallback" },
		["<C-y>"] = { "select_and_accept", "fallback" },
		--
		["<S-Tab>"] = { "snippet_forward", "fallback" },
		["<Tab>"] = {},
		--
		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback_to_mappings" },
		["<C-j>"] = { "select_next", "fallback_to_mappings" },
		--
		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },
		--
		["<C-l>"] = { "show_signature", "hide_signature", "fallback" },
	},

	appearance = {
		-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",
	},

	-- (Default) Only show the documentation popup when manually triggered
	completion = {
		menu = { border = "single" },
		documentation = { auto_show = false },

		keyword = { range = "full" },
	},

	signature = { window = { border = "single" }, enabled = true }, -- Default list of enabled providers defined so that you can extend it

	cmdline = {
		keymap = {
			-- recommended, as the default keymap will only show and select the next item
			["<Tab>"] = { "show", "accept" },
			-- ["<CR>"] = { "accept_and_enter", "fallback" },
			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback_to_mappings" },
			["<C-j>"] = { "select_next", "fallback_to_mappings" },
		},
		completion = {
			menu = {
				auto_show = function(ctx)
					return vim.fn.getcmdtype() == ":"
				end,
			},
		},
	},

	-- elsewhere in your config, without redefining it, due to `opts_extend`
	snippets = { preset = "luasnip" },

	sources = {
		default = {
			"lsp",
			"path",
			"snippets",
			"buffer",
		},

		providers = {
			cmdline = {
				min_keyword_length = function(ctx)
					-- when typing a command, only show when the keyword is 3 characters or longer
					if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
						return 3
					end
					return 0
				end,
			},
		},

		per_filetype = {
			markdown = {
				"lsp",
				"path",
				"snippets",
			},
			tex = {
				"lsp",
				"path",
				"snippets",
			},
		},
	},

	fuzzy = { implementation = "prefer_rust_with_warning" },
})
