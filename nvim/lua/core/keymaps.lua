local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ============================================================================
-- EDITOR BASICS
-- ============================================================================

map("i", "jk", "<Esc>", opts)
map("n", "<Esc>", "<cmd>nohlsearch<cr>", opts)

-- Save & Quit
map("n", "<leader>w", "<cmd>w<cr>", opts)
map("n", "<leader>q", "<cmd>q<cr>", opts)

-- ============================================================================
-- WINDOWS
-- ============================================================================

-- Navigate windows
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize windows
map("n", "<C-Up>", ":resize +2<cr>", opts)
map("n", "<C-Down>", ":resize -2<cr>", opts)
map("n", "<C-Left>", ":vertical resize -2<cr>", opts)
map("n", "<C-Right>", ":vertical resize +2<cr>", opts)

-- Split
map("n", "<leader>-", "<C-w>s", opts)        -- Split below
map("n", "<leader>|", "<C-w>v", opts)        -- Split right

-- ============================================================================
-- BUFFERS (SIMPLIFIED!)
-- ============================================================================

map("n", "<C-n>", "<cmd>bnext<cr>", opts)        -- Next buffer
map("n", "<C-p>", "<cmd>bprevious<cr>", opts)    -- Previous buffer
map("n", "<C-w>", "<cmd>bdelete<cr>", opts)      -- Close buffer

-- ============================================================================
-- FILES & EXPLORER
-- ============================================================================

map("n", "<C-b>", "<cmd>Explore<cr>", opts)      -- File explorer

-- Telescope
pcall(function()
  local tb = require("telescope.builtin")
  map("n", "<leader>ff", tb.find_files, opts)
  map("n", "<leader>/", tb.live_grep, opts)
end)

-- ============================================================================
-- SEARCH
-- ============================================================================

map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- ============================================================================
-- LSP
-- ============================================================================

map("n", "gd", function() vim.lsp.buf.definition() end, opts)
map("n", "gr", function() vim.lsp.buf.references() end, opts)
map("n", "gi", function() vim.lsp.buf.implementation() end, opts)
map("n", "K", function() vim.lsp.buf.hover() end, opts)
map("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
map("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)

-- Diagnostics
map("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
map("n", "]d", function() vim.diagnostic.goto_next() end, opts)

-- Format
map("n", "<leader>f", function()
  pcall(function() require("conform").format({ async = true }) end)
end, opts)

-- ============================================================================
-- TEXT MOVEMENT
-- ============================================================================

map("n", "H", "^", opts)        -- Start of line
map("n", "L", "$", opts)        -- End of line

-- Move lines
map("n", "<A-j>", ":m .+1<cr>==", opts)
map("n", "<A-k>", ":m .-2<cr>==", opts)
map("v", "<A-j>", ":m '>+1<cr>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<cr>gv=gv", opts)

-- ============================================================================
-- DIFF & UNDO
-- ============================================================================

map("n", "<leader>dd", "<cmd>diffthis<cr>", opts)
map("n", "<leader>do", "<cmd>diffoff<cr>", opts)

map("n", "<leader>u1", "<cmd>earlier 1m<cr>", opts)
map("n", "<leader>u2", "<cmd>earlier 10m<cr>", opts)
map("n", "<leader>u3", "<cmd>earlier 1h<cr>", opts)
