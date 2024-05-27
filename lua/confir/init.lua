local M = {}

M.setup = function(user_config)
	require("confir.config").set(user_config)
	local confirm = require("confir.confirm")

	vim.fn.confirm = confirm.confir
end

return M
