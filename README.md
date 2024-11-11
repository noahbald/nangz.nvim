# 🎈 Nangz.nvim

Noah's Awesome Neovim GUI in Zellij

https://github.com/user-attachments/assets/c49d655d-2129-485c-b534-62805745642f

## ✨ Features

This is intended to be a drop-in replacement for some of the UI defaults provided by lazyvim. You'll find the performance of running TUIs in Zellij much faster than the overhead of running them within Neovim.

| Lazyvim Keymap              | Replacement     | Setup Required |
| --------------------------- | --------------- | -------------- |
| Find files (Root Dir)       | Nangz fzf_files | No             |
| Grep (Root Dir)             | Nangz fzf_grep  | No             |
| GitUi (Root Dir)            | Nangz lazygit   | No             |
| Explorer NeoTree (Root Dir) | Nangz yazi      | No             |

## ⚡ Requirements

- Neovim >= v0.10.2 (Earlier versions may work too)
- _nushell_ is used for communication between Zellij and Neovim
- _fzf_ is used as the telescope ui
- _ripgrep_ is used for search functionality
- _lazygit_ is used as the git ui
- _yazi_ is used as the explorer ui

## 📦 Installation

Install the plugin with your manager

### Lazyvim

```lua
{
  "noahbald/nangz.nvim",
}
```

<details>
  <summary>Advanced options</summary>

```lua
{
	{
		"noahbald/nangz.nvim",
    --- NOTE: The following are all setup by default
		keys = {
			{ "<leader>gg", "<cmd>Nangz lazygit<cr>", desc = "Lazygit" },
			{ "<leader>e", "<cmd>Nangz yazi<cr>", desc = "Explorer Yazi (Root dir)" },
			{ "<leader>E", "<cmd>Nangz yazi_cwd<cr>", desc = "Toggle Yazi (cwd)" },
			{ "<leader><space>", "<cmd>Nangz fzf_files<cr>", desc = "Find Files (Root dir)" },
			{ "<leader>/", "<cmd>Nangz fzf_grep<cr>", desc = "Grep (Root dir)" },
		},
		cmd = "Nangz",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
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
    },
  },
}
```

</details>

## 🛠️ Troubleshooting

- **Commands aren't working after updating Zellij?**
  Try detatching and re-attatching to your session in a new Zellij instance

- **Yazi is appearing in a weird position?**
  You should try updating the options returned in `opts.commands.yazi.zellij.floating` to position the floating window in a more ideal position

- **Lazygit is loading in the wrong pane?**
  The cause I'm not sure on, but it can be an issue when using swap layouts
