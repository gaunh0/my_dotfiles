-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Update tabline on buffer changes
vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete", "BufEnter", "BufModifiedSet" }, {
  group = vim.api.nvim_create_augroup("tabline_update", { clear = true }),
  callback = function()
    vim.cmd("redrawtabline")
  end,
})

-- ===============
-- TABLINE COLORS
-- ===============
vim.api.nvim_set_hl(0, "TabLineSel", {
  fg = "#ffffff",
  bg = "#2563eb",
  bold = true,
})

vim.api.nvim_set_hl(0, "TabLine", {
  fg = "#888888",
  bg = "#1e1e1e",
})

vim.api.nvim_set_hl(0, "TabLineFill", {
  fg = "#666666",
  bg = "#1e1e1e",
})

-- Update colors when colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("tabline_colors", { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, "TabLineSel", {
      fg = "#ffffff",
      bg = "#2563eb",
      bold = true,
    })
    vim.api.nvim_set_hl(0, "TabLine", {
      fg = "#888888",
      bg = "#1e1e1e",
    })
    vim.api.nvim_set_hl(0, "TabLineFill", {
      fg = "#666666",
      bg = "#1e1e1e",
    })
  end,
})

-- ===============
-- NETRW KEYMAPS & COLORS
-- ===============
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    local opts = { noremap = true, silent = true, buffer = true }
    
    -- Navigation keymaps
    vim.keymap.set("n", "H", ":NetrwUp<CR>", opts)
    vim.keymap.set("n", "h", ":Ex<CR>", opts)
    vim.keymap.set("n", "l", "<CR>", opts)
    vim.keymap.set("n", ".", "gh", opts)
    vim.keymap.set("n", "~", "t", opts)
    vim.keymap.set("n", "R", "R", opts)
    vim.keymap.set("n", "D", "D", opts)
    vim.keymap.set("n", "M", "m", opts)
    vim.keymap.set("n", "A", "a", opts)
    
    -- Colors for netrw
    vim.api.nvim_set_hl(0, "netrwDir", {
      fg = "#00d4ff",
      bold = true,
    })
    vim.api.nvim_set_hl(0, "netrwExe", {
      fg = "#00ff00",
    })
  end,
})
