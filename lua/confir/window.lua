local util = require("confir.util")
local W = {}

local get_relative_position = function(width, height, win_options)
	local current_win_width = vim.api.nvim_win_get_width(0)
	local current_win_height = vim.api.nvim_win_get_height(0)

	if current_win_width < width or current_win_height < height then
		return "cursor"
	else
		return win_options.relative
	end
end

local get_win_config = function(title, height, width)
	local win_options = require("confir.config").get().win_options
	local relative = get_relative_position(width, height, win_options)
	local position = util.positions[win_options.position]

	local margin = win_options.margin
	local is_cursor = relative == "cursor"
	local is_win = relative == "win"

	return {
		relative = relative,
		anchor = position.anchor,
		width = width,
		height = height,
		row = position.row(is_cursor, is_win, height, margin),
		col = position.col(is_cursor, is_win, width, margin),
		style = "minimal",
		border = win_options.border,
		title = title,
		title_pos = title and win_options.title_pos,
		focusable = true,
		noautocmd = true,
		zindex = 100,
	}
end

local set_buf_options = function(buf, content)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
	vim.api.nvim_set_option_value("filetype", "ConfirDialog", { buf = buf })
end

local set_win_options = function(win)
	local ns_id = vim.api.nvim_create_namespace("confir")
	vim.api.nvim_win_set_hl_ns(win, ns_id)
	vim.api.nvim_set_option_value(
		"winhighlight",
		string.format("Normal:NormalNC,FloatTitle:%s,FloatBorder:%s", W.type.color, W.type.color),
		{ win = win }
	)
end

local format_window_title = function(title)
	local icon = W.type.icon
	return string.format(" %s %s ", icon, title)
end

local format_description = function(description)
	local content = {}
	for line in string.gmatch(description, "[^\n]+") do
		local formatted_line = string.format(" %s ", line)
		table.insert(content, formatted_line)
	end
	return content
end

local get_title_and_description = function(msg)
	local title, description = string.match(msg, "^(.-)\n(.*)")

	if not description then
		return nil, format_description(msg)
	end

	title = format_window_title(title or msg)
	description = format_description(description)

	return title, description
end

local get_max_width = function(title, description, choices)
	local title_width = title and title:len() or 0
	local choices_width = choices and choices:len() or 0
	local description_width = #description > 0 and math.max(unpack(description):len()) or 0
	return math.max(title_width, description_width, choices_width)
end

local format_choices = function(choices)
	local choice_list = {}
	if choices then
		for _, choice in ipairs(choices) do
			local first_char = choice:sub(1, 1)
			local rest_of_string = choice:sub(2)
			local formatted_choice = string.format("(%s)%s", first_char, rest_of_string)
			table.insert(choice_list, formatted_choice)
		end
		local formatted_choices = table.concat(choice_list, " ")
		return string.format(" %s ", formatted_choices)
	else
		return " [Press any key to continue] "
	end
end

W.create_window = function(msg, choices, type)
	local config = require("confir.config").get()
	W.type = {
		icon = type and config.icons[type] or config.icon.generic,
		color = type and config.colors[type] or config.colors.generic,
	}
	local title, description = get_title_and_description(msg)
	local formatted_choices = format_choices(choices)

	local win_width = get_max_width(title, description, formatted_choices)

	if vim.fn.has("nvim-0.10") ~= 1 then
		local empty_line = ""
		local padded_choices = util.add_padding_left(formatted_choices, win_width)

		table.insert(description, empty_line)
		table.insert(description, padded_choices)
	end

	local win_config = get_win_config(title, #description, win_width)

	if vim.fn.has("nvim-0.10") == 1 then
		win_config.footer = formatted_choices
		win_config.footer_pos = config.win_options.footer_pos
	end

	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, false, win_config)

	set_buf_options(buf, description)
	set_win_options(win)

	return win
end

return W
