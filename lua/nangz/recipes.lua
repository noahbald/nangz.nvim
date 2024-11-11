local dirname = string.sub(debug.getinfo(1).source, 2, string.len("/lua/nangz/recipes.lua") * -1)

local yazi_config_home = dirname .. "/zellij/yazi"
local open_file = dirname .. "/zellij/open_file.nu"
local quick_fix = dirname .. "/zellij/quick_fix.nu"

---@class Recipes
return {
	fzf = {
		command = {
			rg = {
				"--disabled",
				"--ansi",
				"--multi",
				"--bind",
				"start:reload:rg --column --color=always --smart-case {q}",
				"--bind",
				"change:reload:rg --column --color=always --smart-case {q}",
				"--delimiter",
				":",
			},
		},
		preview = {
			bat = {
				"--preview",
				"bat -n --color=always {}",
			},
			bat_line = {
				"--preview",
				"bat --color=always --highlight-line {2} {1}",
				"--preview-window",
				"~4,+{2}+4/3,<80(up)",
			},
		},
		bind = {
			open_file = {
				"--bind",
				"enter:become(nu " .. open_file .. " {1} {2})",
			},
			quickfix = {
				"--bind",
				"ctrl-q:select-all+become(nu " .. quick_fix .. " {+f})",
			},
		},
	},

	yazi = {
		env = {
			config_home = "YAZI_CONFIG_HOME=" .. yazi_config_home,
		},
	},

	lazygit = {},
}
