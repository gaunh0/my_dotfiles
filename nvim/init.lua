-- =========================
-- Neovim 0.12 Minimal Config
-- Organized & Clean
-- =========================

vim.g.mapleader = " "

-- Set tabline FIRST (before loading plugins)
vim.opt.showtabline = 2 -- Always show tabline
vim.opt.tabline = '%!v:lua.require("core.tabline").setup()'

-- Load all modules
require("core.options")
require("core.keymaps")
require("core.autocmds")
require("plugins.setup")

-- Load plugins from vim.pack
local plugins = {
  "nvim-treesitter",
  "telescope.nvim",
  "nvim-lspconfig",
  "nvim-cmp",
  "cmp-nvim-lsp",
  "conform.nvim",
  "mason.nvim",
  "mason-lspconfig.nvim",
  "plenary.nvim",
  "LuaSnip",
  "friendly-snippets",
}

for _, plugin in ipairs(plugins) do
  local plugin_path = vim.fn.expand("~/.local/share/nvim/site/pack/nvim/start/" .. plugin)
  if vim.fn.isdirectory(plugin_path) == 1 then
    vim.cmd("packadd " .. plugin)
  end
end

-- Update tabline (ensure it's set)
vim.opt.tabline = '%!v:lua.require("core.tabline").setup()'

-- THEME

vim.cmd("packadd tokyonight.nvim")
vim.cmd("colorscheme tokyonight")

print("✅ Neovim loaded!")
