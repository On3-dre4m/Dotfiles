local root_markers1 = {
	".emmyrc.json",
	".luarc.json",
	".luarc.jsonc",
}
local root_markers2 = {
	".luacheckrc",
	".stylua.toml",
	"stylua.toml",
	"selene.toml",
	"selene.yml",
}

return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers1, root_markers2, { ".git" } } or vim.list_extend(vim.list_extend(root_markers1, root_markers2), { ".git" }),
	settings = {
		Lua = {
			codeLens = { enable = true },
			hint = { enable = true, semicolon = "Disable" },
			-- 	runtime = {
			-- 		-- Tell Lua language server to use Lua 5.1 (LuaJIT) which is used by Neovim
			-- 		version = "LuaJIT",
			-- 		-- Setup Neovim runtime files for completion
			-- 		path = vim.split(package.path, ";"),
			-- 	},
			-- 	diagnostics = {
			-- 		-- Recognize `vim` global
			-- 		globals = { "vim" },
			-- 	},
			-- 	workspace = {
			-- 		-- Make the server aware of Neovim runtime files
			-- 		-- library = vim.api.nvim_get_runtime_file("", true),
			-- 		library = { vim.env.VIMRUNTIME },
			-- 		-- Stop prompting about 'luassert' or third-party libraries
			-- 		checkThirdParty = false,
			-- 	},
			-- 	telemetry = {
			-- 		-- Disable telemetry data collection
			-- 		enable = false,
			-- 	},
		},
	},
}
