-- GLOBAL VARIBLES
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_view_general_viewer = "okular"
vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_fold_manual = true
vim.g.vimtex_compiler_latexmk = {
	aux_dir = ".texfiles/",
	out_dir = ".texfiles/",
}
