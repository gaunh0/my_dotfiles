local OXLINT_CONFIGS = { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts", "oxlint.config.js", "oxlint.config.mjs", "oxlint.config.cjs" }

local function get_cmd()
	local local_cmd = vim.fn.getcwd() .. "/node_modules/.bin/oxlint"
	if vim.fn.executable(local_cmd) == 1 then return { local_cmd } end
	if vim.fn.executable("oxlint") == 1 then return { "oxlint" } end
	return { "oxc_language_server" }
end

local function conf_mentions_typescript(root_dir)
	if not root_dir then return false end
	for _, name in ipairs(OXLINT_CONFIGS) do
		local path = root_dir .. "/" .. name
		if vim.fn.filereadable(path) == 1 then
			local content = table.concat(vim.fn.readfile(path), "\n")
			if content:find("typescript") or content:find("@typescript") then return true end
		end
	end
	return false
end

---@type vim.lsp.Config
return {
	cmd       = get_cmd(),
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro" },
	workspace_required = true,
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local root  = vim.fs.dirname(vim.fs.find(OXLINT_CONFIGS, { path = fname, upward = true, stop = vim.env.HOME })[1])
		on_dir(root)
	end,
	on_attach = function(client, bufnr)
		if conf_mentions_typescript(client.config.root_dir) then
			client.config.settings = vim.tbl_deep_extend("force", client.config.settings or {}, {
				oxlintrc = { enableTypeChecking = true },
			})
		end
		vim.api.nvim_buf_create_user_command(bufnr, "LspOxlintFixAll", function()
			client:request("workspace/executeCommand", {
				command   = "oxc.fixAll",
				arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
			}, nil, bufnr)
		end, { desc = "Oxlint Fix All" })
	end,
	settings = {
		oxlintrc = { fixKind = "safe_fix" },
	},
}
