local map = vim.keymap.set

local palette = {
	err  = "#51202A",
	warn = "#3B3B1B",
	info = "#1F3342",
	hint = "#1E2E1E",
}

vim.api.nvim_set_hl(0, "DiagnosticErrorLine", { bg = palette.err,  blend = 20 })
vim.api.nvim_set_hl(0, "DiagnosticWarnLine",  { bg = palette.warn, blend = 15 })
vim.api.nvim_set_hl(0, "DiagnosticInfoLine",  { bg = palette.info, blend = 10 })
vim.api.nvim_set_hl(0, "DiagnosticHintLine",  { bg = palette.hint, blend = 10 })

vim.api.nvim_set_hl(0, "DapBreakpointSign", { fg = "#FF0000", bold = true })
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpointSign", linehl = "", numhl = "" })

local sev = vim.diagnostic.severity

vim.diagnostic.config({
	underline        = true,
	severity_sort    = true,
	update_in_insert = false,
	float            = { border = "rounded", source = true },
	signs = {
		text = {
			[sev.ERROR] = " ",
			[sev.WARN]  = " ",
			[sev.INFO]  = " ",
			[sev.HINT]  = "󰌵 ",
		},
	},
	virtual_text = {
		spacing = 4,
		source  = "if_many",
		prefix  = "●",
	},
	linehl = {
		[sev.ERROR] = "DiagnosticErrorLine",
	},
})

local function goto_diagnostic(next, severity)
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		vim.diagnostic.jump({ count = next and 1 or -1, float = true, severity = severity })
	end
end

map("n", "<leader>cd", vim.diagnostic.open_float,        { desc = "Line Diagnostics" })
map("n", "]d",         goto_diagnostic(true),            { desc = "Next Diagnostic" })
map("n", "[d",         goto_diagnostic(false),           { desc = "Prev Diagnostic" })
map("n", "]e",         goto_diagnostic(true,  "ERROR"),  { desc = "Next Error" })
map("n", "[e",         goto_diagnostic(false, "ERROR"),  { desc = "Prev Error" })
map("n", "]w",         goto_diagnostic(true,  "WARN"),   { desc = "Next Warning" })
map("n", "[w",         goto_diagnostic(false, "WARN"),   { desc = "Prev Warning" })
