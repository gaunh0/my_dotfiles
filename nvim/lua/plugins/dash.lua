return {
    "snacks.nvim",
    opts = {
        dashboard = {
            preset = {
                pick = function(cmd, opts)
                    return LazyVim.pick(cmd, opts)()
                end,
                header = [[
         ██████╗  █████╗ ██╗   ██╗███╗   ██╗██╗  ██╗ ██████╗
        ██╔════╝ ██╔══██╗██║   ██║████╗  ██║██║  ██║██╔═████╗
        ██║  ███╗███████║██║   ██║██╔██╗ ██║███████║██║██╔██║
        ██║   ██║██╔══██║██║   ██║██║╚██╗██║██╔══██║████╔╝██║
        ╚██████╔╝██║  ██║╚██████╔╝██║ ╚████║██║  ██║╚██████╔╝
         ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝
        ]],
                -- stylua: ignore
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = function() Snacks.dashboard.pick("files") end },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = function() Snacks.dashboard.pick("live_grep") end },
                    {
                        icon = " ",
                        key = "r",
                        desc = "Recent Files",
                        action = function()
                            Snacks.dashboard.pick(
                                "oldfiles")
                        end
                    },
                    {
                        icon = " ",
                        key = "c",
                        desc = "Config",
                        action = function()
                            Snacks.dashboard.pick("files",
                                { cwd = vim.fn.stdpath("config") })
                        end
                    },
                    { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                    { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
                    { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
            -- Cấu hình lại sections


            sections = {
                { section = "header" },
                { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
                { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
                { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
                { section = "startup" },
            },

            -- Footer an toàn hơn
            footer = function()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                return {
                    " ",
                    "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms",
                    "  " .. os.date("%d-%m-%Y") .. "    " .. os.date("%H:%M"),
                }
            end,
        },
    },
}
