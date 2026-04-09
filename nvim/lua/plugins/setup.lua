-- ================================
-- TREESITTER
-- ================================
pcall(function()
  require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "python", "javascript", "typescript", "tsx", "html", "css", "rust", "c", "cpp", "bash", "json", "yaml", "markdown" },
    highlight = { enable = true },
  })
end)

-- ================================
-- DIAGNOSTICS
-- ================================
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

local signs = { Error = "✖", Warn = "⚠", Hint = "ℹ", Info = "ℹ" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- ================================
-- LSP HANDLERS (Fixed - no deprecated vim.lsp.with()!)
-- ================================
local border = "rounded"

-- Hover with border (new API - no deprecation!)
vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
  config = config or {}
  config.border = border
  return vim.lsp.handlers.hover(err, result, ctx, config)
end

-- Signature help with border (new API - no deprecation!)
vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
  config = config or {}
  config.border = border
  return vim.lsp.handlers.signature_help(err, result, ctx, config)
end

-- ================================
-- LSP CONFIG (New 0.12 API)
-- ================================
pcall(function()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  
  -- Lua
  vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } },
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
        },
      },
    },
    capabilities = capabilities,
  })
  
  -- Python
  vim.lsp.config('pyright', {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', '.git' },
    capabilities = capabilities,
  })
  
  -- TypeScript
  vim.lsp.config('ts_ls', {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    root_markers = { 'tsconfig.json', 'package.json', '.git' },
    capabilities = capabilities,
  })
  
  vim.lsp.enable('lua_ls')
  vim.lsp.enable('pyright')
  vim.lsp.enable('ts_ls')
end)

-- ================================
-- COMPLETION
-- ================================
pcall(function()
  local cmp = require("cmp")
  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping.select_next_item(),
      ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
    }),
  })
end)

-- ================================
-- MASON
-- ================================
pcall(function()
  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "pyright", "ts_ls" },
    automatic_installation = true,
  })
end)

-- ================================
-- CONFORM (Formatter)
-- ================================
pcall(function()
  require("conform").setup({
    formatters_by_ft = {
      python = { "black" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      lua = { "stylua" },
    },
    format_on_save = { lsp_format = "fallback" },
  })
end)
