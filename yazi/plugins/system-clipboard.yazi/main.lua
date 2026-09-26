-- Meant to run at async context. (yazi system-clipboard)

local selected_or_hovered = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, u in pairs(tab.selected) do
		paths[#paths + 1] = tostring(u)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

return {
	entry = function()
		ya.emit("escape", { visual = true })

		local urls = selected_or_hovered()

		if #urls == 0 then
			return ya.notify({ title = "System Clipboard", content = "No file selected", level = "warn", timeout = 5 })
		end

		-- ya.notify({ title = #urls, content = table.concat(urls, " "), level = "info", timeout = 5 })

		local cmd = "snap run clipboard copy" -- Replace full path to clipboard
		for _, url in ipairs(urls) do
			cmd = cmd .. " " .. '"' .. url .. '"'
		end

		cmd = cmd .. " > /dev/null 2>&1"

		local success, err_msg, err_code = os.execute(cmd)

		if success then
			ya.notify({
				title = "System Clipboard",
				content = "Successfully copied the file(s) to system clipboard",
				level = "info",
				timeout = 5,
			})
		end

		if not success then
			ya.notify({
				title = "System Clipboard",
				content = string.format("Could not copy selected file(s): %s", err_msg .. " " .. tostring(err_code)),
				level = "error",
				timeout = 5,
			})
		end
	end,
}
