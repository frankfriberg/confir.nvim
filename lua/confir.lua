local config = require("confir.config")
local confirm = require("confir.confirm")
local M = {}

local update = function(user_config)
  vim.tbl_deep_extend("force", config, user_config or {})
  return config
end

M.setup = function(user_config)
  config = update(user_config)

  vim.fn.confirm = confirm.confir
end

return M
