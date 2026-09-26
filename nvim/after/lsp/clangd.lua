local clang_cmd = {}
local idf_path = os.getenv("IDF_PATH")
local home_dir = os.getenv("HOME")

if idf_path then
	local esp_clangd_path = vim.fn.system('find $HOME/.espressif -name "clangd"')
	esp_clangd_path = vim.trim(esp_clangd_path)

	-- Use ESP32 clangd if IDF_PATH is set
	clang_cmd = { "clangd", "--compile-commands-dir=build", "--query-driver=" .. home_dir .. "/.espressif/tools/xtensa-esp-elf/esp-14.2.0_20241119/xtensa-esp-elf/bin/xtensa-esp32-elf-gcc" }
else
	-- Use regular clangd from Mason
	clang_cmd = { "clangd", "--query-driver=/opt/gcc-arm/bin/arm-none-eabi-gcc" }
end

return {
	cmd = clang_cmd,
}
