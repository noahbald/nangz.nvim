return {
	{
		"noahbald/nangz.nvim",
		keys = {
			{ "<leader>gg", "<cmd>Nangz lazygit<cr>", desc = "Lazygit" },
			{ "<leader>e", "<cmd>Nangz yazi<cr>", desc = "Explorer Yazi (Root dir)" },
			{ "<leader>E", "<cmd>Nangz yazi_cwd<cr>", desc = "Toggle Yazi (cwd)" },
			{ "<leader><space>", "<cmd>Nangz fzf_files<cr>", desc = "Find Files (Root dir)" },
			{ "<leader>/", "<cmd>Nangz fzf_grep<cr>", desc = "Grep (Root dir)" },
		},
		cmd = "Nangz",
		opts = {},
		dependencies = { "nvim-lua/plenary.nvim" },
	},
}
