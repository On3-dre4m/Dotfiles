-- Multi-terminal Floating Window Plugin
--
-- This plugin allows management of multiple floating terminal windows in Neovim.

local M = {}

-- State to store multiple terminal instances
local terminals = {}

-- Track the currently active terminal ID
local active_terminal_id = nil

-- Track the last used terminal ID
local last_used_id = 1

-- Function to deactivate currently active terminal if any
local function deactivate_active_terminal()
	if active_terminal_id and terminals[active_terminal_id] then
		local term = terminals[active_terminal_id]
		if vim.api.nvim_win_is_valid(term.win) then
			-- Hide the window of the currently active terminal
			vim.api.nvim_win_hide(term.win)
		end
	end
end

-- Create a floating window for a terminal
-- This function creates a floating window with specified options, ensuring proper
-- buffer validation to prevent errors when opts.buf is not a valid number
local function create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)

	-- Calculate the position to center the window
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	-- Create a buffer
	local buf = nil
	-- FIX: Added type checking to prevent "Invalid 'buffer': Expected Lua number" error
	-- Neovim buffer IDs must be numbers, so we validate type before calling nvim_buf_is_valid()
	if opts.buf and type(opts.buf) == "number" and vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
	end

	-- Define window configuration
	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal", -- No borders or extra UI elements
		border = "rounded",
	}

	-- Create the floating window
	local win = vim.api.nvim_open_win(buf, true, win_config)

	return { buf = buf, win = win }
end

-- Toggle terminal with a specific ID
M.toggle_terminal = function(id)
	id = id or last_used_id -- Use last used ID if none provided

	-- Deactivate the currently active terminal before activating a new one
	if active_terminal_id ~= id then
		deactivate_active_terminal()
	end

	if not terminals[id] then
		-- Create new terminal instance
		terminals[id] = create_floating_window()
		vim.cmd("terminal")
		-- Set a unique name for the terminal buffer to identify it
		vim.api.nvim_buf_set_name(terminals[id].buf, "Floaterminal_" .. id)
	else
		-- Check if window is valid
		if vim.api.nvim_win_is_valid(terminals[id].win) then
			-- Hide the window if it's currently visible
			vim.api.nvim_win_hide(terminals[id].win)
			-- Reset active terminal ID since we're hiding it
			if active_terminal_id == id then
				active_terminal_id = nil
			end
		else
			-- Create a new floating window for this terminal
			terminals[id] = create_floating_window({ buf = terminals[id].buf })
			if vim.bo[terminals[id].buf].buftype ~= "terminal" then
				vim.cmd("terminal")
			end
		end
	end

	-- If the window is not hidden, make it active
	if vim.api.nvim_win_is_valid(terminals[id].win) then
		vim.api.nvim_set_current_win(terminals[id].win)
		vim.cmd("startinsert")
		active_terminal_id = id -- Set this terminal as the active one
	else
		-- If we're hiding the window, and it was active, clear active ID
		if active_terminal_id == id then
			active_terminal_id = nil
		end
	end

	last_used_id = id -- Remember this ID as the last used
end

-- Keymap functions for different terminal IDs
M.term1_toggle = function()
	M.toggle_terminal(1)
end

M.term2_toggle = function()
	M.toggle_terminal(2)
end

-- Setup default keymaps (you can customize these)
vim.keymap.set("t", "``", "<c-\\><c-n>")
vim.keymap.set({ "n", "t" }, "<M-`>", M.term1_toggle, { desc = "Toggle Terminal 1" })
vim.keymap.set({ "n", "t" }, "<M-1>", M.term2_toggle, { desc = "Toggle Terminal 2" })

-- Completion function for command
-- function M.complete_ids(arg, cmd, pos)
-- 	local ids = {}
-- 	for id, _ in pairs(terminals) do
-- 		table.insert(ids, tostring(id))
-- 	end
-- 	return ids
-- end

return M
