local M = {}

local relative_height = function(is_cursor, is_win)
	if is_cursor then
		return vim.fn.winline()
	elseif is_win then
		return vim.api.nvim_win_get_height(0)
	else
		return vim.o.lines
	end
end

local relative_width = function(is_win)
	if is_win then
		return vim.api.nvim_win_get_width(0)
	else
		return vim.o.columns
	end
end

local get_left_position = function(is_cursor, _, win_width, margin)
	if is_cursor then
		return -win_width + margin.left + 1
	else
		return margin.left or 0
	end
end

local get_center_position = function(is_cursor, is_win, win_width, _)
	if is_cursor then
		return -(win_width / 2)
	else
		return (relative_width(is_win) - win_width) / 2
	end
end

local get_right_position = function(is_cursor, is_win, win_width, margin)
	if is_cursor then
		return win_width + margin.right
	else
		return relative_width(is_win) - win_width - margin.right
	end
end

local get_top_position = function(is_cursor, _, win_height, margin)
	if is_cursor then
		return margin.top - 1
	else
		return margin.top
	end
end

local get_middle_position = function(is_cursor, is_win, win_height, _)
	if is_cursor then
		return win_height / 2
	else
		return (relative_height(is_cursor, is_win) - win_height) / 2
	end
end

local get_bottom_position = function(is_cursor, is_win, _, margin)
	if is_cursor then
		return margin.bottom + 1
	else
		return relative_height(is_cursor, is_win) - vim.o.cmdheight - margin.bottom
	end
end

M.add_padding_left = function(text, win_width)
	local text_width = text:len()
	local left_padding = (win_width - text_width) / 2
	local left_spaces = string.rep(" ", left_padding)
	return left_spaces .. text
end

M.positions = {
	["bottom-left"] = {
		row = get_bottom_position,
		col = get_left_position,
		anchor = "SW",
	},
	["bottom-center"] = {
		row = get_bottom_position,
		col = get_center_position,
		anchor = "SW",
	},
	["bottom-right"] = {
		row = get_bottom_position,
		col = get_right_position,
		anchor = "SE",
	},
	["top-left"] = {
		row = get_top_position,
		col = get_left_position,
		anchor = "NW",
	},
	["top-center"] = {
		row = get_top_position,
		col = get_center_position,
		anchor = "NW",
	},
	["top-right"] = {
		row = get_top_position,
		col = get_right_position,
		anchor = "NE",
	},
	["center-center"] = {
		row = get_middle_position,
		col = get_center_position,
		anchor = "NW",
	},
}

M.get_col_row_anchor = function(win_options, win_width, win_height)
	local position = win_options.position
	local relative = win_options.relative
	local margin = win_options.margin

	local is_cursor = relative == "cursor"
	local is_win = relative == "win"

	if position == "bottom-left" then
		return {
			row = get_bottom_position(is_cursor, is_win, margin),
			col = get_left_position(is_cursor, win_width, margin),
			anchor = "SW",
		}
	elseif position == "bottom-center" then
		return {
			row = get_bottom_position(is_cursor, is_win, margin),
			col = get_center_position(is_cursor, is_win, win_width),
			anchor = "SW",
		}
	elseif position == "bottom-right" then
		return {
			row = get_bottom_position(is_cursor, is_win, margin),
			col = get_right_position(is_cursor, is_win, win_width, margin),
			anchor = "SE",
		}
	elseif position == "top-left" then
		return {
			row = get_top_position(is_cursor, win_height, margin),
			col = get_left_position(is_cursor, win_width, margin),
			anchor = "NW",
		}
	elseif position == "top-center" then
		return {
			row = get_top_position(is_cursor, win_height, margin),
			col = get_center_position(is_cursor, is_win, win_width),
			anchor = "NW",
		}
	elseif position == "top-right" then
		return {
			row = get_top_position(is_cursor, win_height, margin),
			col = get_right_position(is_cursor, is_win, win_width, margin),
			anchor = "NE",
		}
	elseif position == "center-center" then
		return {
			row = get_middle_position(is_cursor, is_win, win_height),
			col = get_center_position(is_cursor, is_win, win_width),
			anchor = "NW",
		}
	else
		return {
			row = 0,
			col = 0,
			anchor = "NW",
		}
	end
end

return M
