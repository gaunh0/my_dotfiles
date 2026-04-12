return {
  {
    "navarasu/onedark.nvim",
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
      require("onedark").load()

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
}
