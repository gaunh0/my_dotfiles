local function augroup(name)
	return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Debounced checktime: reload files changed outside nvim
local _checktime_timer = nil
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	callback = function()
		if _checktime_timer then _checktime_timer:stop(); _checktime_timer:close(); _checktime_timer = nil end
		_checktime_timer = vim.defer_fn(function()
			_checktime_timer = nil
			if vim.o.buftype ~= "nofile" then vim.cmd("checktime") end
		end, 200)
	end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group    = augroup("highlight_yank"),
	callback = function() (vim.hl or vim.highlight).on_yank() end,
})

-- Debounced split resize
local _resize_timer = nil
vim.api.nvim_create_autocmd("VimResized", {
	group = augroup("resize_splits"),
	callback = function()
		if _resize_timer then _resize_timer:stop(); _resize_timer:close(); _resize_timer = nil end
		local cur = vim.fn.tabpagenr()
		_resize_timer = vim.defer_fn(function()
			_resize_timer = nil
			vim.cmd("tabdo wincmd =")
			vim.cmd("tabnext " .. cur)
		end, 100)
	end,
})

-- Restore cursor position (skip gitcommit)
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(ev)
		if vim.tbl_contains({ "gitcommit" }, vim.bo[ev.buf].filetype) then return end
		if vim.b[ev.buf].last_loc_set then return end
		vim.b[ev.buf].last_loc_set = true
		local mark   = vim.api.nvim_buf_get_mark(ev.buf, '"')
		local lcount = vim.api.nvim_buf_line_count(ev.buf)
		if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
	end,
})

-- Kebab-case: treat '-' as word char in CSS/HTML/JSX
vim.api.nvim_create_autocmd("FileType", {
	group   = augroup("iskeyword_kebab"),
	pattern = { "css", "scss", "less", "html", "htmldjango", "blade", "typescriptreact", "javascriptreact" },
	callback = function() vim.opt_local.iskeyword:append("-") end,
})

-- Insert mode: disable cursorline + relativenumber (perf)
vim.api.nvim_create_autocmd("InsertEnter", {
	group    = augroup("insert_ui_perf"),
	callback = function() vim.wo.cursorline = false; vim.wo.relativenumber = false; vim.wo.number = true end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	group    = augroup("insert_ui_perf"),
	callback = function() vim.wo.cursorline = true; vim.wo.relativenumber = true end,
})

-- Unlist man pages
vim.api.nvim_create_autocmd("FileType", {
	group   = augroup("man_unlisted"),
	pattern = { "man" },
	callback = function(ev) vim.bo[ev.buf].buflisted = false end,
})

-- Close auxiliary windows with q
vim.api.nvim_create_autocmd("FileType", {
	group   = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup", "checkhealth", "dbout", "gitsigns-blame",
		"grug-far", "help", "lspinfo", "neotest-output",
		"neotest-output-panel", "neotest-summary", "notify",
		"qf", "spectre_panel", "startuptime", "tsplayground",
	},
	callback = function(ev)
		vim.bo[ev.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set("n", "q", function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, ev.buf, { force = true })
			end, { buffer = ev.buf, silent = true, desc = "Quit buffer" })
		end)
	end,
})

-- Wrap + spell for text/doc filetypes
vim.api.nvim_create_autocmd("FileType", {
	group   = augroup("wrap_spell"),
	pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
	callback = function() vim.opt_local.wrap = true; vim.opt_local.spell = true end,
})

-- conceallevel = 0 for JSON
vim.api.nvim_create_autocmd("FileType", {
	group   = augroup("json_conceal"),
	pattern = { "json", "jsonc", "json5" },
	callback = function() vim.opt_local.conceallevel = 0 end,
})

-- Auto-create parent directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup("auto_create_dir"),
	callback = function(ev)
		if ev.match:match("^%w%w+:[\\/][\\/]") then return end
		local file = vim.uv.fs_realpath(ev.match) or ev.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Filetype: .env → sh
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group   = augroup("env_filetype"),
	pattern = { "*.env", ".env.*" },
	callback = function() vim.opt_local.filetype = "sh" end,
})

-- Filetype: .ejs → embedded_template
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group   = augroup("ejs_filetype"),
	pattern = { "*.ejs", "*.ejs.t" },
	callback = function() vim.opt_local.filetype = "embedded_template" end,
})

-- Filetype: .code-snippets → json
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group   = augroup("code_snippets_filetype"),
	pattern = { "*.code-snippets" },
	callback = function() vim.opt_local.filetype = "json" end,
})
