local config = require("confir.config")
M = {}

local win_options = config.win_options
local relative = win_options.relative
local margin = win_options.margin

local is_cursor = relative == "cursor"
local is_win = relative == "win"

local relative_height = function()
  if is_cursor then
    return vim.fn.winline()
  elseif is_win then
    return vim.api.nvim_win_get_height(0)
  else
    return vim.o.lines
  end
end

local relative_width = function()
  if is_win then
    return vim.api.nvim_win_get_width(0)
  else
    return vim.o.columns
  end
end

local get_left_position = function(win_width)
  if is_cursor then
    return -win_width + margin.left + 1
  else
    return margin.left or 0
  end
end

local get_center_position = function(win_width)
  if is_cursor then
    return -(win_width / 2)
  else
    return (relative_width() - win_width) / 2
  end
end

local get_right_position = function(win_width)
  if is_cursor then
    return win_width + margin.right
  else
    return relative_width() - win_width - margin.right
  end
end

local get_top_position = function(win_height)
  if is_cursor then
    return -win_height - margin.top - 1
  else
    return margin.top
  end
end

local get_middle_position = function(win_height)
  if is_cursor then
    return win_height / 2
  else
    return (relative_height() - win_height) / 2
  end
end

local get_bottom_position = function()
  if is_cursor then
    return margin.bottom + 1
  else
    return relative_height() - vim.o.cmdheight - margin.bottom
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
  }
}

return M
