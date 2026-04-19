-- blink.cmp — Rust-powered completion (replaces nvim-cmp)
-- Loads before lsp.lua alphabetically — capabilities ready before LSP starts.

vim.pack.add({ "https://github.com/Saghen/blink.cmp" })

require("blink.cmp").setup({
  keymap = { preset = "super-tab" },

  fuzzy = {
    -- No Rust binary available — use pure-Lua fallback (no cargo needed)
    implementation = "lua",
  },

  appearance = {
    nerd_font_variant = "mono",
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },

  completion = {
    documentation = {
      auto_show       = true,
      auto_show_delay_ms = 200,
      window          = { border = "rounded" },
    },
    menu = {
      border = "rounded",
      draw   = {
        treesitter = { "lsp" },
        columns    = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
      },
    },
    ghost_text = { enabled = true },
  },

  signature = {
    enabled = true,
    window  = { border = "rounded" },
  },
})
