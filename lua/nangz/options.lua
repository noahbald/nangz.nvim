local recipes = require("nangz.recipes")

---@alias run (Run | fun(): Run)
---@alias lazygitOptions (CommandOptions | fun(): CommandOptions)
---@alias yaziOptions (YaziOptions | fun(): YaziOptions)
---@alias fzfOptions (FZFOptions | fun(): FZFOptions)

---@class NangzOptions
local defaults = {
	commands = {
		lazygit = {
			---@type run
			zellij = { in_place = true, close_on_exit = true, name = "lazygit" },
			options = {
				---@type lazygitOptions
				default = {},
			},
		},
		yazi = {
			---@type run
			zellij = function()
				return {
					floating = { y = 3, x = 1, width = 50, height = vim.api.nvim_win_get_height(0) },
					close_on_exit = true,
				}
			end,
			options = {
				---@type yaziOptions
				cwd = function()
					return {
						env = recipes.yazi.env.config_home,
						cwd = vim.uv.cwd(),
					}
				end,
				---@type yaziOptions
				buf = function()
					return {
						env = recipes.yazi.env.config_home,
						cwd = vim.api.nvim_buf_get_name(0) or vim.uv.cwd() or "",
					}
				end,
			},
		},
		fzf = {
			---@type run
			zellij = { floating = true, close_on_exit = true, name = "fzf" },
			options = {
				---@type fzfOptions
				fd = {
					preview = "bat",
					binds = { "open_file", "quickfix" },
				},
				---@type fzfOptions
				rg = {
					command = "rg",
					preview = "bat_line",
					binds = { "open_file", "quickfix" },
				},
			},
		},
	},
}

---@type { options: NangzOptions, extend: fun(options: NangzOptions) }
local M = {}

M.options = {}

function M.extend(options)
	M.options = vim.tbl_deep_extend("force", defaults, options)
end

return M
