vim.pack.add({ "https://github.com/folke/snacks.nvim" })


require("snacks").setup({
	-- ── Bigfile ─────────────────────────────────────────────────────────────────
	bigfile = {
		enabled = true,
		size = 1.5 * 1024 * 1024,
		setup = function(ctx)
			vim.b[ctx.buf].bigfile = true
			vim.opt_local.syntax = "off"
			vim.opt_local.undofile = false
			vim.opt_local.swapfile = false
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.cursorline = false
			vim.opt_local.relativenumber = false
			vim.opt_local.signcolumn = "no"
			vim.opt_local.synmaxcol = 0
			vim.schedule(function()
				pcall(vim.treesitter.stop, ctx.buf)
			end)
		end,
	},

	-- ── Dashboard ───────────────────────────────────────────────────────────────
	dashboard = {
		enabled = true,
		preset = {
			header = [[
  ██████╗  █████╗ ██╗   ██╗███╗   ██╗██╗  ██╗ ██████╗
 ██╔════╝ ██╔══██╗██║   ██║████╗  ██║██║  ██║██╔═████╗
 ██║  ███╗███████║██║   ██║██╔██╗ ██║███████║██║██╔██║
 ██║   ██║██╔══██║██║   ██║██║╚██╗██║██╔══██║████╔╝██║
 ╚██████╔╝██║  ██║╚██████╔╝██║ ╚████║██║  ██║╚██████╔╝
  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝]],
			keys = {
				{ icon = " ", key = "f", desc = "Find File",    action = function() Snacks.picker.files() end },
				{ icon = " ", key = "n", desc = "New File",     action = ":ene | startinsert" },
				{ icon = " ", key = "g", desc = "Find Text",    action = function() Snacks.picker.grep() end },
				{ icon = " ", key = "r", desc = "Recent Files", action = function() Snacks.picker.recent() end },
				{
					icon = " ",
					key = "c",
					desc = "Config",
					action = function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,
				},
				{
					icon = " ",
					key = "s",
					desc = "Restore Session",
					action = function()
						local session_dir = vim.fn.stdpath("state") .. "/sessions/"
						local session_file = session_dir .. vim.fn.getcwd():gsub("/", "%%") .. ".vim"
						if vim.fn.filereadable(session_file) == 1 then
							vim.cmd("source " .. vim.fn.fnameescape(session_file))
						else
							vim.notify("No session for current directory", vim.log.levels.WARN)
						end
					end,
				},
				{ icon = " ", key = "q", desc = "Quit",         action = ":qa" },
			},
		},
		sections = {
			{ section = "header" },
			{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
			{ icon = " ", title = "Projects",     section = "projects",     indent = 2, padding = 1 },
			function()
				local ms = math.floor((vim.uv.hrtime() - vim.g._nvim_start_time) / 1e6)
				return {
					text = {
						{ "⚡ Neovim loaded in " .. ms .. "ms", hl = "SnacksDashboardFooter" },
						{ "\n  " .. os.date("%d-%m-%Y") .. "    " .. os.date("%H:%M"), hl = "SnacksDashboardFooter" },
					},
					align = "center",
					padding = 1,
				}
			end,
		},
	},

	-- ── Explorer ────────────────────────────────────────────────────────────────
	explorer = {
		enabled = true,
		replace_netrw = true,
		backdrop = false,
		position = "float",
		border = true,
		title_pos = "center",
		height = 1,
		width = 60,
		relative = "editor",
		noautocmd = true,
		row = 2,
		-- relative = "cursor",
		-- row = -3,
		-- col = 0,
		wo = {
			winhighlight = "NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
			cursorline = false,
		},
		bo = {
			filetype = "snacks_input",
			buftype = "prompt",
		},
		--- buffer local variables
		b = {
			completion = false, -- disable blink completions in input
		},
		keys = {
			n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n", expr = true },
			i_esc = { "<esc>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
			i_cr = { "<cr>", { "cmp_accept", "confirm" }, mode = { "i", "n" }, expr = true },
			i_tab = { "<tab>", { "cmp_select_next", "cmp" }, mode = "i", expr = true },
			i_ctrl_w = { "<c-w>", "<c-s-w>", mode = "i", expr = true },
			i_up = { "<up>", { "hist_up" }, mode = { "i", "n" } },
			i_down = { "<down>", { "hist_down" }, mode = { "i", "n" } },
			q = "cancel",
		},
	},

	-- ── Indent ──────────────────────────────────────────────────────────────────
	indent = {
		enabled = true,
		char = "│",
		scope = { enabled = true, char = "│" },
		filter = function(buf)
			local excluded_ft = {
				alpha = true,
				help = true,
				man = true,
				startify = true,
				NvimTree = true,
				Trouble = true,
				notify = true,
				lazy = true,
				mason = true,
				terminal = true,
				toggleterm = true,
				dashboard = true,
				lspinfo = true,
				snacks_dashboard = true,
			}
			local excluded_bt = { terminal = true, nofile = true, quickfix = true, prompt = true }
			return not excluded_ft[vim.bo[buf].filetype] and not excluded_bt[vim.bo[buf].buftype]
		end,
	},

	-- ── Input / Notifier ────────────────────────────────────────────────────────
	input = { enabled = true },
	notifier = { enabled = true, timeout = 4000 },

	-- ── Picker (replaces Telescope) ─────────────────────────────────────────────
	picker = {
		enabled = true,
		layout = { preset = "telescope" },
		win = {
			input = {
				keys = {
					["<C-j>"] = { "list_down", mode = { "i", "n" } },
					["<C-k>"] = { "list_up", mode = { "i", "n" } },
					["<C-q>"] = { "qflist", mode = { "i", "n" } },
					["<Esc>"] = { "close", mode = { "i", "n" } },
				},
			},
		},
	},

	-- ── Utilities ───────────────────────────────────────────────────────────────
	bufdelete = { enabled = true },
	rename = { enabled = true },
})

-- Find plugin file
vim.keymap.set("n", "<leader>fp", function()
	local ok, lazy_config = pcall(require, "lazy.core.config")
	local plugin_root = ok and lazy_config.options.root or (vim.fn.stdpath("data") .. "/site/pack")
	Snacks.picker.files({ cwd = plugin_root })
end, { desc = "Find Plugin File" })
