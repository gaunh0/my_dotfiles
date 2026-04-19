-- Statusline + tabline are custom (lua/config/statusline.lua, tabline.lua)
-- Colorscheme is in lua/config/theme.lua
-- Dashboard, indent-guides, bigfile → snacks.nvim (lua/plugins/snacks.lua)

vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/NvChad/nvim-colorizer.lua",
})

-- Colorizer ────────────────────────────────────────────────────────────────────
require("colorizer").setup({
  filetypes            = { "*" },
  user_default_options = { RGB = true, RRGGBB = true, names = true, css = true, css_fn = true, mode = "background" },
})
