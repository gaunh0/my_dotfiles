vim.pack.add({ "https://github.com/williamboman/mason.nvim" })

require("mason").setup({
  ui = {
    border = "rounded",
    icons  = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
  },
})

-- Global capabilities (blink.lua loads before this file alphabetically)
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- LspAttach: keymaps + inlay hints + document color ───────────────────────────
local default_keymaps = {
  { keys = "<leader>ca", func = vim.lsp.buf.code_action,       desc = "Code Actions" },
  { keys = "<leader>cr", func = vim.lsp.buf.rename,            desc = "Code Rename" },
  { keys = "<leader>cl", func = function()
      if vim.fn.exists(":LspOxlintFixAll") > 0 then
        vim.cmd("LspOxlintFixAll")
      elseif vim.fn.exists(":LspEslintFixAll") > 0 then
        vim.cmd("LspEslintFixAll")
      else
        vim.lsp.buf.code_action({ apply = true, context = { only = { "source.fixAll" }, diagnostics = {} } })
      end
    end, desc = "LSP Fix All" },
  { keys = "K",          func = vim.lsp.buf.hover,             desc = "Hover docs",         has = "hoverProvider" },
  { keys = "gd",         func = vim.lsp.buf.definition,        desc = "Go to definition",   has = "definitionProvider" },
  { keys = "gD",         func = vim.lsp.buf.declaration,       desc = "Go to declaration" },
  { keys = "gr",         func = vim.lsp.buf.references,        desc = "References" },
  { keys = "gi",         func = vim.lsp.buf.implementation,    desc = "Implementation" },
  { keys = "grt",        func = vim.lsp.buf.type_definition,   desc = "Type definition",    has = "typeDefinitionProvider" },
  { keys = "grx",        func = vim.lsp.codelens.run,          desc = "Run codelens",       has = "codeLensProvider" },
  { keys = "<leader>ls", func = vim.lsp.buf.signature_help,    desc = "Signature help" },
  -- Note: [d/]d/[e/]e/[w/]w are defined globally in config/diagnostics.lua
}

vim.api.nvim_create_autocmd("LspAttach", {
  group    = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local buf    = args.buf
    if not client then return end

    -- Inlay hints (toggle off during insert)
    if client:supports_method("textDocument/inlayHints") then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
      if not vim.b[buf].inlay_hints_autocmd_set then
        vim.api.nvim_create_autocmd("InsertEnter", {
          buffer   = buf,
          callback = function() vim.lsp.inlay_hint.enable(false, { bufnr = buf }) end,
        })
        vim.api.nvim_create_autocmd("InsertLeave", {
          buffer   = buf,
          callback = function() vim.lsp.inlay_hint.enable(true, { bufnr = buf }) end,
        })
        vim.b[buf].inlay_hints_autocmd_set = true
      end
    end

    -- Document color
    if client:supports_method("textDocument/documentColor") then
      vim.lsp.document_color.enable(true, { bufnr = buf }, { style = "virtual" })
    end

    -- Keymaps (only if server supports it)
    for _, km in ipairs(default_keymaps) do
      if not km.has or client.server_capabilities[km.has] then
        vim.keymap.set(km.mode or "n", km.keys, km.func, {
          buffer = buf, silent = true, desc = "LSP: " .. km.desc,
        })
      end
    end
  end,
})

-- Enable servers — each reads its config from lsp/<name>.lua
local ts_server = vim.g.lsp_typescript_server or "vtsls"

vim.lsp.enable({
  ts_server,
  "oxlint",
  "eslint",
  "lua_ls",
  "gopls",
  "rust_analyser",
  "pyright",
  "jsonls",
  "biome",
  -- "cssls",
  -- "html",
})

-- Load on-demand servers (e.g. vim.g.lsp_on_demands = {"eslint"})
if vim.g.lsp_on_demands then
  vim.lsp.enable(vim.g.lsp_on_demands)
end
