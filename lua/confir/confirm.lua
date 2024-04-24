local window = require("confir.window")
local M = {}

M.choice = nil

M.parse_choices = function(choices)
	if not choices then
		return nil, nil
	end

	local parsed_choices = {}
	local input_strings = {}

	for choice in choices:gmatch("&([^\n]+)") do
		table.insert(parsed_choices, choice)
	end

	for i, choice in ipairs(parsed_choices) do
		local first_char = choice:sub(1, 1)
		local upper_case = first_char:upper()
		local lower_case = first_char:lower()

		input_strings[upper_case] = i
		input_strings[lower_case] = i
	end

	return parsed_choices, input_strings
end

M.confir = function(msg, choices, default, type)
	local parsed_choices, input_strings = M.parse_choices(choices)
	local win = window.create_window(msg, parsed_choices, type)

	vim.cmd("redraw")
	local choice = vim.fn.getcharstr()

	vim.api.nvim_win_close(win, true)

	if input_strings ~= nil then
		return input_strings[choice]
	else
		return default
	end
end

return M
