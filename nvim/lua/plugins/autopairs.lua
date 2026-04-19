vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })

require("nvim-autopairs").setup({ check_ts = true })
-- Note: no cmp/blink hook needed — blink.cmp handles bracket pairing natively
