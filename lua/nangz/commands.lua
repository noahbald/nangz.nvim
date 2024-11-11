local zellij = require("nangz.zellij")

local M = {}

M.lazygit = function()
	local lazygit = require("nangz.options").options.commands.lazygit
	zellij.run(lazygit.zellij).lazygit().job():start()
end

M.yazi_cwd = function()
	local yazi = require("nangz.options").options.commands.yazi
	zellij.run(yazi.zellij()).yazi(yazi.options.cwd()).job():start()
end

M.yazi = function()
	local options = require("nangz.options").options
	zellij.run(options.commands.yazi.zellij()).yazi(options.commands.yazi.options.buf()).job():start()
end

M.fzf_files = function()
	local fzf = require("nangz.options").options.commands.fzf
	zellij.run(fzf.zellij).fzf(fzf.options.fd).job():start()
end

M.fzf_grep = function()
	local fzf = require("nangz.options").options.commands.fzf
	zellij.run(fzf.zellij).fzf(fzf.options.rg).job():start()
end

return M
