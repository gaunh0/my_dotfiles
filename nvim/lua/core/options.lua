-- All vim.opt settings in one place
local opt = vim.opt

-- Display
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"

-- Editing
opt.wrap = true
opt.linebreak = true
opt.scrolloff = 8
opt.mouse = "a"
opt.clipboard = "unnamedplus"

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Tabs & Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Undo (Persistent)
opt.undofile = true
opt.undodir = vim.fn.expand("~/.local/share/nvim/undodir")
opt.undolevels = 10000
opt.undoreload = 100000

-- Diff
opt.diffopt:append("iwhite")
opt.diffopt:append("algorithm:histogram")

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.wildmenu = true

-- Misc
opt.updatetime = 200

-- ===============
-- BEAUTIFUL NETRW
-- ===============
vim.g.netrw_banner = 0              -- Hide banner
vim.g.netrw_liststyle = 3           -- Tree style
vim.g.netrw_winsize = 25            -- Window width
vim.g.netrw_localrmdir = 'rm -r'    -- Delete directories
vim.g.netrw_sizestyle = "H"         -- Show size in human format
vim.g.netrw_sort_sequence = '[/]$,*'  -- Sort by directories first
vim.g.netrw_list_hide = ''          -- Show all files

