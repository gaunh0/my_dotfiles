-- ui2: native Neovim 0.12+ message/cmdline redesign
-- provides pager as a buffer+window.
local ok, ui2 = pcall(require, "vim._core.ui2")
if not ok then return end

ui2.enable({
	enable = true,
	msg = {
		targets = "cmd",
		cmd = {
			height = 0.5,
		},
		dialog = {
			height = 0.5,
		},
		msg = {
			height = 0.5,
			timeout = 4000,
		},
		pager = {
			height = 1,
		},
	},
})
