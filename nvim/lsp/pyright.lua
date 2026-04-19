---@type vim.lsp.Config
return {
	cmd          = { "pyright-langserver", "--stdio" },
	filetypes    = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
	settings = {
		python = {
			analysis = {
				autoSearchPaths        = true,
				useLibraryCodeForTypes = true,
				diagnosticMode         = "openFilesOnly",
			},
		},
	},
	on_attach = function(client, bufnr)
		local function set_python_path(path)
			for _, c in ipairs(vim.lsp.get_clients({ name = "pyright", bufnr = bufnr })) do
				c.config.settings = vim.tbl_deep_extend("force", c.config.settings, { python = { pythonPath = path } })
				c:notify("workspace/didChangeConfiguration", { settings = nil })
			end
		end

		vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightOrganizeImports", function()
			client:request("workspace/executeCommand", {
				command   = "pyright.organizeimports",
				arguments = { vim.uri_from_bufnr(bufnr) },
			}, nil, bufnr)
		end, { desc = "Organize Imports" })

		vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightSetPythonPath", function(opts)
			set_python_path(opts.args)
		end, { desc = "Set Python path", nargs = 1 })
	end,
}
