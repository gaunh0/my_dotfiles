return {
  "nvim-lua/plenary.nvim",

  -- dashboard
  {
    "nvimdev/dashboard-nvim",
    lazy = false,
    opts = {
      theme = "doom",
      config = {
        header = {
          "",
          " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
          " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
          " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
          " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
          " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
          " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
          "",
        },
        center = {
          { icon = "  ", key = "f", desc = "Find File", action = "Telescope find_files" },
          { icon = "  ", key = "n", desc = "New File", action = "enew" },
          { icon = "  ", key = "r", desc = "Recent Files", action = "Telescope oldfiles" },
          { icon = "  ", key = "g", desc = "Find Text", action = "Telescope live_grep" },
          { icon = "  ", key = "q", desc = "Quit", action = "qa" },
        },
        footer = {},
      },
    },
  },

  -- theme
  -- {
  --   "navarasu/onedark.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("onedark").setup { style = "dark" }
  --     require("onedark").load()
  --   end,
  -- },
  --
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "darker",
        transparent = true, -- 🔥 transparent
        term_colors = true,

        diagnostics = {
          darker = true,
          undercurl = true,
          background = true,
        },
      })
      vim.cmd.colorscheme "onedark"

      -- Optional: make common UI backgrounds transparent too
      local groups = {
        "Normal",
        "NormalNC",
        "SignColumn",
        "FoldColumn",
        "LineNr",
        "CursorLineNr",
        "EndOfBuffer",
        "NormalFloat",
        "FloatBorder",
        "Pmenu",
        "PmenuSbar",
        "PmenuThumb",
        "TelescopeNormal",
        "TelescopeBorder",
        "NeoTreeNormal",
        "NeoTreeNormalNC",
      }
      for _, g in ipairs(groups) do
        vim.api.nvim_set_hl(0, g, { bg = "none" })
      end
    end,
  },
  -- icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    opts = {
      options = {
        theme = "onedark",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
    },
  },

  -- buffer tabs (replaces nvchad tabufline)
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    opts = {
      options = {
        offsets = {
          { filetype = "NvimTree", text = "File Explorer", text_align = "center" },
        },
      },
    },
  },

  -- indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    opts = {
      indent = { char = "│" },
      scope = { char = "│" },
    },
    config = function(_, opts)
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)
    end,
  },

  -- file tree
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "configs.nvimtree"
    end,
  },

  -- which-key
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    opts = {},
  },

  -- formatting
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },

  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = {
      signs = {
        delete = { text = "󰍵" },
        changedelete = { text = "󱕖" },
      },
    },
  },

  -- mason
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    opts = {
      PATH = "skip",
      ui = {
        icons = {
          package_pending = " ",
          package_installed = " ",
          package_uninstalled = " ",
        },
      },
      max_concurrent_installers = 10,
    },
  },

  -- lsp
  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require("luasnip.loaders.from_vscode").lazy_load()
          -- fix luasnip #258
          vim.api.nvim_create_autocmd("InsertLeave", {
            callback = function()
              local ls = require "luasnip"
              if ls.session.current_nodes[vim.api.nvim_get_current_buf()] and not ls.session.jump_active then
                ls.unlink_current()
              end
            end,
          })
        end,
      },
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "https://codeberg.org/FelipeLema/cmp-async-path.git",
    },
    opts = function()
      return require "configs.cmp"
    end,
  },

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require "configs.telescope"
    end,
  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "lua", "luadoc", "printf", "vim", "vimdoc" },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },

  -- terminal (replaces nvchad.term)
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4)
        end
      end,
      float_opts = { border = "curved" },
    },
  },

  -- image preview
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          floating_windows = false,
          filetypes = { "markdown", "vimwiki" },
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          floating_windows = false,
          filetypes = { "norg" },
        },
      },
      max_width = 100,
      max_width_percent = 0.5,
      max_height = 12,
      max_height_percent = 0.4,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      editor_only_render_when_focused = true,
      tmux_show_only_in_active_window = true,
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
    },
  },

  -- telescope media files (image preview in telescope)
  {
    "dharmx/telescope-media-files.nvim",
    dependencies = { "3rd/image.nvim" },
    config = function()
      require("telescope").load_extension "media_files"
    end,
  },
}
