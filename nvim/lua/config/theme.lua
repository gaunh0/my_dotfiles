vim.pack.add({ "https://github.com/navarasu/onedark.nvim" })

require("onedark").setup({
  style = "darker",
  transparent = true,
  term_colors = true,
  diagnostics = {
    darker = true,
    undercurl = true,
    background = true,
  },
})
require("onedark").load()

local groups = {
  "Normal", "NormalNC", "SignColumn", "FoldColumn",
  "LineNr", "CursorLineNr", "EndOfBuffer",
  "NormalFloat", "FloatBorder",
  "Pmenu", "PmenuSbar", "PmenuThumb",
  "TelescopeNormal", "TelescopeBorder",
  "NeoTreeNormal", "NeoTreeNormalNC",
}
for _, g in ipairs(groups) do
  vim.api.nvim_set_hl(0, g, { bg = "none" })
end
