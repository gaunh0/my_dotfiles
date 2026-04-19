-- Orchestrates loading order ──────────────────────────────────────────────────
require("config.options")
require("config.theme")       -- colorscheme first so highlights are available
require("config.ui2")         -- Neovim 0.12+ message/cmdline redesign
require("config.statusline")
require("config.tabline")
require("config.autocmds")
require("config.diagnostics")

-- Auto-load every file in lua/plugins/ alphabetically.
-- blink.lua (b) sorts before lsp.lua (l), so blink capabilities
-- are registered before any LSP server starts.
local plugins_dir = vim.fn.stdpath("config") .. "/lua/plugins"
local files = vim.fn.glob(plugins_dir .. "/*.lua", false, true)
table.sort(files)
for _, f in ipairs(files) do
  require("plugins." .. vim.fn.fnamemodify(f, ":t:r"))
end

require("config.keymaps") -- always last: all plugins are loaded by now
require("config.session")  -- after keymaps: session keymaps use <leader>q*
require("config.packui")   -- register :Pack user command
