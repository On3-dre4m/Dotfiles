vim.pack.add({ { src = "https://github.com/mikavilpas/yazi.nvim", name = "yazi" } })
-- "mikavilpas/yazi.nvim",
require("yazi").setup({
	-- if you want to open yazi instead of netrw, see below for more info
	open_for_directories = false,
	keymaps = {
		show_help = "<f1>",
	},
})

-- 👇 in this section, choose your own keymappings!
vim.keymap.set({ "n", "v" }, "<leader>e", "<cmd>Yazi<cr>", {
	desc = "Open yazi at the current file",
})
vim.keymap.set("n", "<leader>cw", "<cmd>Yazi cwd<cr>", {
	desc = "Open the file manager in nvim's working directory",
})

---
---
vim.pack.add({ { src = "https://github.com/folke/which-key.nvim", name = "which-key" } })
vim.keymap.set("n", "<leader>?", function()
	require("which-key").show({ global = true })
end, { desc = "Buffer Local Keymaps (which-key)" })

vim.pack.add({ { src = "https://github.com/stevearc/resession.nvim", name = "resession" } })
local resession = require("resession")
resession.setup({})

-- Resession does NOTHING automagically, so we have to set up some keymaps
vim.keymap.set("n", "<leader>ss", resession.save)
vim.keymap.set("n", "<leader>sl", resession.load)
vim.keymap.set("n", "<leader>sd", resession.delete)

---
---
vim.pack.add({ { src = "https://github.com/lervag/vimtex", name = "vimtex" } })
