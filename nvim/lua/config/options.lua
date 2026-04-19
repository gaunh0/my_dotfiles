local opt = vim.opt

-- Line numbers
opt.number         = true  -- Show absolute line number on the current line.
opt.relativenumber = true  -- Show relative line numbers for fast motions.
opt.cursorline     = true  -- Highlight the line under the cursor.
opt.signcolumn     = "yes" -- Always keep sign column visible (no text shifting).
opt.showmode       = false -- Hide default mode text (statusline handles it).
opt.wrap = false -- Don't wrap lines


-- Indentation
opt.tabstop     = 2 -- Render a tab character as 2 spaces.
opt.shiftwidth  = 2 -- Use 2 spaces for auto-indent operations.
opt.expandtab   = true -- Insert spaces instead of real tab characters.
opt.smartindent = true -- Enable smart auto-indentation on new lines.
opt.autoindent = true -- Copy indent from current line


-- Search
opt.ignorecase = true -- Ignore case in search patterns by default.
opt.smartcase  = true -- Re-enable case sensitivity when uppercase is used.
opt.hlsearch   = false -- incremental search is enough
opt.incsearch  = true -- Show matches while typing the search pattern.
opt.grepprg    = "rg --vimgrep" -- Use ripgrep for :grep.
opt.grepformat = "%f:%l:%c:%m" -- Parse ripgrep output as file:line:col:message.

-- Splits
opt.splitright = true -- Open vertical splits to the right.
opt.splitbelow = true -- Open horizontal splits below.
opt.splitkeep = "screen"


-- Files
opt.swapfile   = false -- Disable swap files.
opt.backup     = false -- Disable backup files on write.
opt.undofile   = true -- Persist undo history to disk.
opt.undodir    = vim.fn.stdpath("data") .. "/undodir" -- Directory for undo files.
opt.undolevels = 10000 -- Keep a deep undo history.
opt.autoread   = true   -- reload files changed outside nvim
opt.autowrite  = true   -- auto-save before :make, buffer switch, etc.

-- Visual settings
opt.termguicolors = true -- Enable 24-bit colors
opt.signcolumn = "yes" -- Always show sign column
opt.showmatch = true -- Highlight matching brackets
opt.matchtime = 2 -- How long to show matching bracket
opt.cmdheight = 1 -- Command line height
opt.showmode = false -- Don't show mode in command line
opt.pumheight = 10 -- Popup menu height
opt.pumblend = 10 -- Popup menu transparency
opt.pummaxwidth = 60 -- cap completion popup width
opt.winblend = 0 -- Floating window transparency
opt.completeopt = "menu,menuone,noselect,popup" -- popup shows completionItem/resolve preview
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.concealcursor = "" -- Don't hide cursor line markup
opt.synmaxcol = 300 -- Syntax highlighting limit
opt.ruler = false -- Disable the default ruler
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.winminwidth = 5 -- Minimum window width


-- Clipboard (skip in SSH to avoid OSC52 issues)
if not vim.env.SSH_TTY then
  opt.clipboard = "unnamedplus" -- Use system clipboard register by default.
end

-- Window borders
opt.winborder = "rounded" -- Use rounded borders for floating windows.

-- Virtualedit: allow cursor past EOL in block mode
opt.virtualedit = "block" -- Allow blockwise selection past end-of-line.

-- Diff
opt.diffopt:append("linematch:60") -- Improve diff alignment with line matching.

-- Folding (treesitter-driven, off by default)
opt.foldmethod = "expr" -- Compute folds from an expression.
opt.foldexpr   = "nvim_treesitter#foldexpr()" -- Use Treesitter for fold levels.
opt.foldenable = false -- Start with folds open.
opt.foldtext   = "" -- Show plain text in folded lines.

-- Wildmenu
opt.wildmode = "longest:full,full" -- Command-line completion mode behavior.

-- Matching brackets: flash for 200ms
opt.matchtime = 2 -- Duration for matching bracket highlight (tenths of sec).

-- Filetype associations

vim.filetype.add({
	extension = {
		env = "dotenv",
	},
	filename = {
		[".env"] = "dotenv",
		["env"] = "dotenv",
	},
	pattern = {
		["[jt]sconfig.*.json"] = "jsonc",
		["%.env%.[%w_.-]+"] = "dotenv",
	},
})

