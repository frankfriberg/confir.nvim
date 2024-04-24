local ns_id = vim.api.nvim_create_namespace("confir")

if vim.api.nvim_win_set_hl_ns then
	vim.api.nvim_set_hl(ns_id, "NormalFloat", { bg = "NONE" })
	vim.api.nvim_set_hl(ns_id, "FloatBorder", { bg = "NONE" })
end

local config = {
	max_width = 40,
	ns_id = ns_id,
	types = {
		error = {
			icon = "󰅚",
			color = "ErrorFloat",
		},
		question = {
			icon = "",
			color = "HintFloat",
		},
		info = {
			icon = "",
			color = "InfoFloat",
		},
		warning = {
			icon = "",
			color = "Comment",
		},
		generic = {
			icon = "",
			color = "WarningFloat",
		},
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

return config
