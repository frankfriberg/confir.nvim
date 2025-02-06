local C = {}

local options = {
	max_width = 40,
	colors = {
		generic = "DiagnosticHint",
		question = "DiagnosticOk",
		info = "DiagnosticInfo",
		warning = "DiagnosticWarn",
		error = "DiagnosticError",
	},
	icons = {
		generic = "",
		question = "",
		info = "",
		warning = "",
		error = "󰅚",
	},
	win_options = {
		relative = "win",
		position = "bottom-left",
		border = "rounded",
		title_pos = "left",
		footer_pos = "center",
		margin = {
			top = 0,
			right = 0,
			bottom = 0,
			left = 0,
		},
	},
}

C.set = function(user_config)
	options = vim.tbl_deep_extend("force", options, user_config or {})
	return options
end

C.get = function()
	return options
end

return C
