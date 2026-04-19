vim.pack.add({ "https://github.com/folke/which-key.nvim" })

local wk = require("which-key")

wk.setup({ preset = "classic" })

wk.add({
	{ "<leader><tab>", group = "tabs" },
	{
		"<leader>b",
		group = "buffer",
		expand = function()
			return require("which-key.extras").expand.buf()
		end,
	},
	{ "<leader>c", group = "code" },
	{ "<leader>d", group = "debug" },
	{ "<leader>f", group = "file/find" },
	{ "<leader>g", group = "git" },
	{ "<leader>gh", group = "hunks" },
	{ "<leader>p", group = "Yanky", icon = { icon = "󰃮 ", color = "yellow" } },
	{ "<leader>q", group = "quit/session" },
	{ "<leader>s", group = "search" },
	{ "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
	{
		"<leader>w",
		group = "windows",
		proxy = "<c-w>",
		expand = function()
			return require("which-key.extras").expand.win()
		end,
	},
	{ "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
	{ "[", group = "prev" },
	{ "]", group = "next" },
	{ "g", group = "goto" },
	{ "gs", group = "surround" },
	{ "z", group = "fold" },
	{ "gx", desc = "Open with system app" },

	-- Copy file path utilities
	{
		"<leader>fC",
		group = "Copy Path",
		{
			"<leader>fCf",
			function()
				vim.fn.setreg("+", vim.fn.expand("%:p"))
				vim.notify("Copied full path: " .. vim.fn.expand("%:p"))
			end,
			desc = "Copy full file path",
		},
		{
			"<leader>fCn",
			function()
				vim.fn.setreg("+", vim.fn.expand("%:t"))
				vim.notify("Copied file name: " .. vim.fn.expand("%:t"))
			end,
			desc = "Copy file name",
		},
		{
			"<leader>fCr",
			function()
				local rel = vim.fn.expand("%:p"):sub(#vim.fn.getcwd() + 2)
				vim.fn.setreg("+", rel)
				vim.notify("Copied relative path: " .. rel)
			end,
			desc = "Copy relative file path",
		},
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer keymaps (which-key)",
		},
		{
			"<c-w><space>",
			function()
				require("which-key").show({ keys = "<c-w>", loop = true })
			end,
			desc = "Window Hydra Mode",
		},
	},

	{ mode = { "n", "v" }, { "<leader>W", "<cmd>w<cr>", desc = "Write" } },
})
