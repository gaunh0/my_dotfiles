local map = vim.keymap.set

-- ── Windows ───────────────────────────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { silent = true, desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { silent = true, desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { silent = true, desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { silent = true, desc = "Window right" })

map("n", "<C-Up>",    ":resize -2<CR>",         { silent = true, desc = "Shrink height" })
map("n", "<C-Down>",  ":resize +2<CR>",          { silent = true, desc = "Grow height" })
map("n", "<C-Left>",  ":vertical resize -2<CR>", { silent = true, desc = "Shrink width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true, desc = "Grow width" })

-- ── Buffers ───────────────────────────────────────────────────────────────────
-- <leader>bl / <leader>br  →  defined in config/tabline.lua
map("n", "<Tab>",     ":bnext<CR>",   { silent = true, desc = "Next buffer" })
map("n", "<S-Tab>",   ":bprev<CR>",   { silent = true, desc = "Prev buffer" })
map("n", "<leader>x", function() Snacks.bufdelete() end, { silent = true, desc = "Close buffer" })

-- ── Explorer ──────────────────────────────────────────────────────────────────
map("n", "<leader>e", function() Snacks.explorer() end, { silent = true, desc = "Toggle file tree" })

-- ── Picker ────────────────────────────────────────────────────────────────────
map("n", "<leader><space>", function() Snacks.picker.files() end,                { silent = true, desc = "Find files" })
map("n", "<leader>/",       function() Snacks.picker.grep() end,                 { silent = true, desc = "Live grep" })
map("n", "<leader>ff", function() Snacks.picker.files() end,                     { silent = true, desc = "Find files" })
map("n", "<leader>fg", function() Snacks.picker.grep() end,                      { silent = true, desc = "Live grep" })
map("n", "<leader>fb", function() Snacks.picker.buffers() end,                   { silent = true, desc = "Buffers" })
map("n", "<leader>fh", function() Snacks.picker.help() end,                      { silent = true, desc = "Help tags" })
map("n", "<leader>fo", function() Snacks.picker.recent() end,                    { silent = true, desc = "Recent files" })
map("n", "<leader>fs", function() Snacks.picker.lsp_symbols() end,               { silent = true, desc = "Document symbols" })
map("n", "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end,     { silent = true, desc = "Workspace symbols" })
map("n", "<leader>fd", function() Snacks.picker.diagnostics() end,               { silent = true, desc = "Diagnostics" })
map("n", "<leader>gc", function() Snacks.picker.git_log() end,                   { silent = true, desc = "Git commits" })
map("n", "<leader>gs", function() Snacks.picker.git_status() end,                { silent = true, desc = "Git status" })

-- ── Editing ───────────────────────────────────────────────────────────────────
map("v", "<",       "<gv",            { silent = true, desc = "Indent left" })
map("v", ">",       ">gv",            { silent = true, desc = "Indent right" })
map("n", "<A-j>",   ":m .+1<CR>==",   { silent = true, desc = "Move line down" })
map("n", "<A-k>",   ":m .-2<CR>==",   { silent = true, desc = "Move line up" })
map("v", "<A-j>",   ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
map("v", "<A-k>",   ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

-- Wrapped-line navigation (only in count=0 context)
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { silent = true, expr = true, desc = "Down (wrapped)" })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { silent = true, expr = true, desc = "Up (wrapped)" })

-- Saner n / N: always forward/backward regardless of search direction
map("n", "n", "'Nn'[v:searchforward].'zv'", { silent = true, expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { silent = true, expr = true, desc = "Prev search result" })
map("x", "n", "'Nn'[v:searchforward]",      { silent = true, expr = true, desc = "Next search result" })
map("x", "N", "'nN'[v:searchforward]",      { silent = true, expr = true, desc = "Prev search result" })
map("o", "n", "'Nn'[v:searchforward]",      { silent = true, expr = true, desc = "Next search result" })
map("o", "N", "'nN'[v:searchforward]",      { silent = true, expr = true, desc = "Prev search result" })

-- Undo breakpoints in insert mode (punctuation creates undo points)
map("i", ",", ",<C-g>u", { desc = "Undo breakpoint ," })
map("i", ".", ".<C-g>u", { desc = "Undo breakpoint ." })
map("i", ";", ";<C-g>u", { desc = "Undo breakpoint ;" })

-- Better indenting in insert mode
map("i", "<C-d>", "<C-d>", { desc = "Dedent" })

-- Fold navigation
map("n", "zj", ":lua vim.cmd('normal! zj')<CR>", { silent = true, desc = "Next fold" })
map("n", "zk", ":lua vim.cmd('normal! [z')<CR>",  { silent = true, desc = "Prev fold start" })

-- ── Misc ──────────────────────────────────────────────────────────────────────
map("n", "<Esc>",      ":nohl<CR>",   { silent = true, desc = "Clear highlights" })
map("n", "<C-s>",      ":w<CR>",      { silent = true, desc = "Save" })
map("i", "<C-s>",      "<Esc>:w<CR>", { silent = true, desc = "Save (insert)" })
map("n", "<leader>Q",  ":qa!<CR>",    { silent = true, desc = "Quit all" })

-- Better paste (don't overwrite register on visual paste)
map("x", "p", '"_dP', { silent = true, desc = "Paste without yank" })

-- Yank to end of line (consistent with D/C)
map("n", "Y", "y$", { desc = "Yank to EOL" })

-- Add blank lines without leaving normal mode
map("n", "]<Space>", "o<Esc>", { silent = true, desc = "Add line below" })
map("n", "[<Space>", "O<Esc>", { silent = true, desc = "Add line above" })
