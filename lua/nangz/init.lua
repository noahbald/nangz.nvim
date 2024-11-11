local commands = require("nangz.commands")

local M = {}

M.zellij = require("nangz.zellij")
M.setup = require("nangz.config").setup

M.lazygit = commands.lazygit
M.yazi = commands.yazi
M.yazi_cwd = commands.yazi_cwd
M.fzf_files = commands.fzf_files
M.fzf_grep = commands.fzf_grep

return M
