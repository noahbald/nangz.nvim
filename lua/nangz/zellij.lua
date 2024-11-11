local recipes = require("nangz.recipes")

local dirname = string.sub(debug.getinfo(1).source, 2, string.len("/lua/nangz/zellij.lua") * -1)
local open_file = dirname .. "/zellij/open_file.nu"
local lazygit_config = dirname .. "/zellij/lazygit/config.yml"

---@class Run
---@field in_place (boolean | nil)
---@field close_on_exit (boolean | nil)
---@field name (string | nil)
---@field floating (boolean | { x?: (string | number), y?: (string | number), width?: (string | number), height?: (string | number) } | nil)

---@class CommandOptions
---@field env (string | nil) # An environment variable, e.g "PATH=/bin"

---@class YaziOptions: CommandOptions
---@field cwd (string | nil)

---@class FZFOptions: CommandOptions
---@field command ("rg" | nil)
---@field preview ("bat" | "bat_line" | nil)
---@field binds ("open_file" | "quickfix")[] | nil

---@class Commands
---@field lazygit fun(options?: CommandOptions): job
---@field yazi fun(options?: YaziOptions): job
---@field fzf fun(options?: FZFOptions): job

---@alias job { job: fun(): Job }

---@param zellij_args string[]
---@param name string
---@return job
local function build_job(zellij_args, name)
	return {
		job = function()
			return require("plenary.job"):new({
				command = "zellij",
				args = zellij_args,
				on_stderr = function(e)
					vim.notify("failed to launch " .. name .. ":\n" .. tostring(e), vim.log.levels.ERROR)
				end,
			})
		end,
	}
end

---@param zellij_args string[]
---@return Commands
local function build_commands(zellij_args)
	table.insert(zellij_args, "--")
	table.insert(zellij_args, "env")
	table.insert(zellij_args, "PATH=" .. vim.env.PATH)
	table.insert(zellij_args, "NANGZ_OPEN=" .. open_file)

	---@param options (CommandOptions | nil)
	local function common_options(options)
		if not options then
			return
		end

		if options.env then
			table.insert(zellij_args, options.env)
		end
	end

	---@type Commands
	return {
		lazygit = function(options)
			common_options(options)
			table.insert(zellij_args, "lazygit")
			require("plenary.job")
				:new({
					command = "lazygit",
					args = { "--print-config-dir" },
					on_exit = function(job)
						local config_dir = job:result()[1]
						if config_dir then
							table.insert(zellij_args, "--use-config-file")
							local config_list = config_dir .. "/config.yml," .. lazygit_config
							table.insert(zellij_args, config_list)
						end
					end,
				})
				:sync()
			return build_job(zellij_args, "lazygit")
		end,

		yazi = function(options)
			common_options(options)
			table.insert(zellij_args, "yazi")
			local name = "yazi"
			if not options then
				return build_job(zellij_args, name)
			end

			if options.cwd then
				table.insert(zellij_args, options.cwd)
			end
			return build_job(zellij_args, name)
		end,

		fzf = function(options)
			common_options(options)
			table.insert(zellij_args, "fzf")
			vim.list_extend(zellij_args, vim.split(vim.env.FZF_DEFAULT_OPTS, "\n"))
			local name = "fzf"
			if not options then
				return build_job(zellij_args, name)
			end

			if options.command then
				vim.list_extend(zellij_args, recipes.fzf.command[options.command])
			end
			if options.preview then
				vim.list_extend(zellij_args, recipes.fzf.preview[options.preview])
			end
			if options.binds then
				for _, bind in ipairs(options.binds) do
					vim.list_extend(zellij_args, recipes.fzf.bind[bind])
				end
			end
			return build_job(zellij_args, name)
		end,
	}
end

return {
	---@param zellij_options Run
	run = function(zellij_options)
		---@type string[]
		local zellij_args = { "run" }
		if zellij_options.in_place then
			table.insert(zellij_args, "-i")
		end
		if zellij_options.close_on_exit then
			table.insert(zellij_args, "-c")
		end
		if zellij_options.name then
			table.insert(zellij_args, "-n")
			table.insert(zellij_args, zellij_options.name)
		end
		if type(zellij_options.floating) == "table" then
			table.insert(zellij_args, "-f")
			if zellij_options.floating.x then
				table.insert(zellij_args, "-x")
				table.insert(zellij_args, zellij_options.floating.x)
			end
			if zellij_options.floating.y then
				table.insert(zellij_args, "-y")
				table.insert(zellij_args, zellij_options.floating.y)
			end
			if zellij_options.floating.width then
				table.insert(zellij_args, "--width")
				table.insert(zellij_args, zellij_options.floating.width)
			end
			if zellij_options.floating.height then
				table.insert(zellij_args, "--height")
				table.insert(zellij_args, zellij_options.floating.height)
			end
		elseif zellij_options.floating then
			table.insert(zellij_args, "-f")
		end

		return build_commands(zellij_args)
	end,
}
