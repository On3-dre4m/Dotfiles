-- NOTE: Here is where you install your plugins.

require("vim-options")
require("vim-options-filetype-based")
require("vim-keymaps")
require("vim-autocmds")
require("vim-usercmds")

require("myplugins.Minimal.floater")
require("myplugins.Minimal.auto-pairs").setup()
require("myplugins.Minimal.statusline").setup()
