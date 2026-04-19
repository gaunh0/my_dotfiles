-- nvim-jump — minimal s-key jump (yorickpeterse)
vim.pack.add({ "https://github.com/yorickpeterse/nvim-jump" })

require("jump").setup({
    labels="123456789",
})

vim.keymap.set({ "n", "x", "o" }, "s", require("jump").start, { desc = "Jump" })
