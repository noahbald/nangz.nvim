local commands = require("nangz.commands")
local _options = require("nangz.options")

local M = {}

---@param options NangzOptions
function M.setup(options)
	_options.extend(options)
	vim.api.nvim_create_user_command("Nangz", function(data)
		if not commands[data.args] then
			vim.notify("Nangz command not found", vim.log.levels.ERROR)
			return
		end
		commands[data.args]()
	end, { nargs = "?" })
end

return M
