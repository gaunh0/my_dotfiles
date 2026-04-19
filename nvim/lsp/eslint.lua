local ESLINT_FLAT_CONFIGS   = { "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs", "eslint.config.ts", "eslint.config.mts", "eslint.config.cts" }
local OXLINT_CONFIGS        = { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts", "oxlint.config.js", "oxlint.config.mjs", "oxlint.config.cjs" }
local WORKSPACE_ROOT_PATTERNS = { ".git", "package.json", "turbo.json", "pnpm-workspace.yaml", "lerna.json", "nx.json", "rush.json", ".eslintrc" }

---@type vim.lsp.Config
return {
	cmd       = { "vscode-eslint-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro", "html" },
	workspace_required = true,

	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		-- Yield to oxlint when its config is present
		local oxlint_root = vim.fs.dirname(vim.fs.find(OXLINT_CONFIGS, { path = fname, upward = true, stop = vim.env.HOME })[1])
		if oxlint_root then on_dir(nil); return end
		-- Workspace root
		local workspace_root = vim.fs.dirname(vim.fs.find(WORKSPACE_ROOT_PATTERNS, { path = fname, upward = true, stop = vim.env.HOME })[1])
		if not workspace_root then on_dir(nil); return end
		-- Activate only when an ESLint 9 flat config exists
		local eslint_cfg = vim.fs.find(ESLINT_FLAT_CONFIGS, { path = workspace_root })[1]
		if not eslint_cfg then on_dir(nil); return end
		on_dir(workspace_root)
	end,

	before_init = function(params, config)
		params.workspaceFolders = {
			{ name = "workspace", uri = vim.uri_from_fname(config.root_dir or vim.fn.getcwd()) },
		}
	end,

	handlers = {
		["eslint/openDoc"]              = function(_, result) if result and result.url then vim.ui.open(result.url) end; return {} end,
		["eslint/confirmESLintExecution"] = function() return 4 end,
		["eslint/probeFailed"]          = function() vim.notify("[eslint] Probe failed", vim.log.levels.WARN); return {} end,
	},

	settings = {
		useFlatConfig  = true,
		validate       = "on",
		format         = false,
		run            = "onType",
		codeAction     = { disableRuleComment = { enable = true }, showDocumentation = { enable = true } },
		codeActionOnSave = { enable = false },
	},
}
