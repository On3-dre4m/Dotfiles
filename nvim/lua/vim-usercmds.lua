local function printFullPath()
	local fullpath = vim.fn.expand("%:p")
	vim.notify(fullpath)
end

local function copyFullPath()
	local filepath = vim.fn.expand("%:p")
	vim.fn.setreg("+", '"' .. filepath .. '"') -- write to clippoard
end

vim.api.nvim_create_user_command("CopyFullPath", function()
	copyFullPath()
end, {})

vim.api.nvim_create_user_command("PrintFullPath", function()
	printFullPath()
end, {})

local function DisableCompletion()
	vim.b.completion = false
	require("blink.cmp").hide()
end

local function EnableCompletion()
	vim.b.completion = true
	require("blink.cmp").hide()
end

vim.api.nvim_create_user_command("DisableCompletion", function()
	DisableCompletion()
end, {})

vim.api.nvim_create_user_command("EnableCompletion", function()
	EnableCompletion()
end, {})
