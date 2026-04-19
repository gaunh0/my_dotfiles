# Neovim Configuration

Cấu hình Neovim cá nhân, xây dựng trên **Neovim 0.12+** với hệ thống plugin native (`vim.pack`), không dùng lazy.nvim hay packer. Mọi thứ đều viết bằng Lua thuần.

---

## Giới thiệu

Đây là một cấu hình Neovim tập trung vào:

- **Tốc độ**: Plugin loader native (`vim.pack`), blink.cmp viết bằng Rust, lazy-load yanky
- **LSP đầy đủ**: Mason + nhiều language server cho TypeScript, Go, Rust, Python, Lua...
- **UI gọn nhẹ**: Statusline / tabline viết tay bằng Lua, không phụ thuộc plugin nặng
- **Workflow hiện đại**: Telescope fuzzy finder, Treesitter, conform.nvim format-on-save
- **Không rác**: Không có plugin dư thừa, mỗi file plugin chỉ làm đúng một việc

---

## Yêu cầu

| Công cụ | Mục đích |
|---|---|
| Neovim >= 0.12 | Bắt buộc (dùng `vim.pack`, `vim.lsp.config`) |
| Git | Plugin manager dùng git |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Telescope live grep + `:grep` |
| [fd](https://github.com/sharkdp/fd) | Telescope find files nhanh hơn |
| Nerd Font | Icon trong statusline, devicons, dashboard |
| C compiler (MSVC / clang / MinGW) | Build Treesitter parser (chạy `:TSInstall` lần đầu) |
| Node.js | Một số LSP server (vtsls, eslint...) |

---

## Cấu trúc thư mục

```
nvim/
├── init.lua                  # Entry point: set leader, load config/
├── stylua.toml               # Formatter config cho Lua
├── lsp/                      # Config từng LSP server (lua_ls, gopls...)
└── lua/
    ├── config/
    │   ├── init.lua          # Thứ tự load: options → theme → ui → keymaps
    │   ├── options.lua       # vim.opt — tất cả tuỳ chọn editor
    │   ├── keymaps.lua       # Keybinding toàn cục
    │   ├── theme.lua         # Colorscheme (tokyonight-night)
    │   ├── statusline.lua    # Statusline tự viết bằng Lua
    │   ├── tabline.lua       # Tabline tự viết bằng Lua
    │   ├── autocmds.lua      # Autocommand tiện ích
    │   ├── diagnostics.lua   # Cấu hình diagnostic UI
    │   ├── session.lua       # Session management per-directory
    │   ├── packui.lua        # User command :Pack
    │   └── ui2.lua           # Neovim 0.12 message/cmdline redesign
    └── plugins/              # Mỗi file = 1 nhóm plugin liên quan
        ├── autopairs.lua
        ├── blink.lua         # Completion (load trước lsp.lua)
        ├── conform.lua       # Format on save
        ├── grug_far.lua      # Search & replace toàn project
        ├── jump.lua          # s-key jump (nvim-jump)
        ├── lsp.lua           # Mason + LspAttach keymaps
        ├── markdown.lua
        ├── telescope.lua     # Fuzzy finder
        ├── tree.lua          # File explorer (nvim-tree)
        ├── treesitter.lua    # Syntax + textobjects
        ├── ui.lua            # Dashboard, colorizer, indent lines
        ├── which_key.lua     # Keymap hints
        └── yanky.lua         # Yank history (lazy-load)
```

---

## Cách cấu hình

### 1. Cài đặt

```bash
# Windows
git clone <repo> %LOCALAPPDATA%\nvim

# Linux / macOS
git clone <repo> ~/.config/nvim
```

Khởi động Neovim — `vim.pack` tự động tải plugin vào `~/.local/share/nvim/site/pack/`.

### 2. Cài Treesitter parser

Lần đầu cần C compiler trên PATH, sau đó chạy:

```
:TSInstall lua typescript javascript go rust python
```

### 3. Cài LSP server qua Mason

```
:Mason
```

Tìm và nhấn `i` để cài server mong muốn. Các server được enable trong `lua/plugins/lsp.lua`:
`vtsls`, `oxlint`, `eslint`, `lua_ls`, `gopls`, `rust_analyser`, `pyright`, `jsonls`, `biome`.

### 4. Tuỳ chỉnh colorscheme

Sửa file `lua/config/theme.lua`:

```lua
vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })
require("tokyonight").setup({ style = "night" }) -- moon / storm / day
vim.cmd.colorscheme("tokyonight-night")
```

### 5. Chọn TypeScript server

Mặc định dùng `vtsls`. Để dùng `tsserver` thay thế:

```lua
-- trong init.lua hoặc một file config nào đó
vim.g.lsp_typescript_server = "tsserver"
```

### 6. Tắt/bật format-on-save

```
:FormatDisable       " tắt toàn cục
:FormatDisable!      " tắt chỉ buffer hiện tại
:FormatEnable        " bật lại
```

Hoặc dùng keymap `<leader>uf`.

---

## Plugins

| Plugin | Tác dụng |
|---|---|
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | Colorscheme |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder (files, grep, buffers...) |
| [telescope-fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | Tăng tốc fuzzy matching với FZF |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | File explorer dạng cây |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlight + fold + textobjects |
| [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | Text object theo function, class, loop... |
| [blink.cmp](https://github.com/Saghen/blink.cmp) | Completion engine viết bằng Rust |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | Cài đặt LSP/linter/formatter |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Format on save đa formatter |
| [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) | Search & replace toàn project (UI) |
| [nvim-jump](https://github.com/yorickpeterse/nvim-jump) | Jump nhanh với phím `s` |
| [yanky.nvim](https://github.com/gbprod/yanky.nvim) | Yank history, cycle qua các lần copy |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Hiển thị keymap hint (preset helix) |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Tự đóng ngoặc / quote |
| [dashboard-nvim](https://github.com/nvimdev/dashboard-nvim) | Màn hình chào khi mở nvim |
| [nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua) | Preview màu hex/rgb trực tiếp trong file |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Hiển thị đường kẻ indent |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | Icon file theo loại |

---

## Keybindings

> Leader key: `Space`

### Navigation & Tìm kiếm

| Phím | Tác dụng |
|---|---|
| `<leader><space>` | **Find files trong project** |
| `<leader>/` | **Live grep toàn project** |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Danh sách buffer |
| `<leader>fo` | File đã mở gần đây |
| `<leader>fh` | Help tags |
| `<leader>fd` | Diagnostics |
| `<leader>fs` | LSP document symbols |
| `<leader>fS` | LSP workspace symbols |
| `s` | Jump nhanh đến vị trí bất kỳ (nhập ký tự + số label) |

### File Explorer

| Phím | Tác dụng |
|---|---|
| `<leader>e` | Bật/tắt file tree |

### Buffer

| Phím | Tác dụng |
|---|---|
| `<Tab>` | Buffer tiếp theo |
| `<S-Tab>` | Buffer trước |
| `<leader>x` | Đóng buffer hiện tại |

### Window

| Phím | Tác dụng |
|---|---|
| `<C-h/j/k/l>` | Di chuyển giữa các window |
| `<C-Up/Down>` | Thay đổi chiều cao window |
| `<C-Left/Right>` | Thay đổi chiều rộng window |
| `<leader>w` | Window group (which-key hydra) |

### LSP

| Phím | Tác dụng |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | References |
| `gi` | Implementation |
| `grt` | Type definition |
| `K` | Hover docs |
| `<leader>ca` | Code actions |
| `<leader>cr` | Rename symbol |
| `<leader>cl` | Fix all (eslint/oxlint) |
| `<leader>ls` | Signature help |

### Diagnostics

| Phím | Tác dụng |
|---|---|
| `[d` / `]d` | Diagnostic trước/sau |
| `[e` / `]e` | Error trước/sau |
| `[w` / `]w` | Warning trước/sau |

### Code & Formatting

| Phím | Tác dụng |
|---|---|
| `<leader>cf` | Format buffer (conform) |
| `<leader>cF` | Format injected languages |
| `<leader>uf` | Toggle autoformat |
| `<leader>sr` | Search & Replace (grug-far) |

### Git

| Phím | Tác dụng |
|---|---|
| `<leader>gc` | Git commits |
| `<leader>gs` | Git status |

### Yank History (yanky)

| Phím | Tác dụng |
|---|---|
| `y` / `p` / `P` | Yank/put có tracking history |
| `<C-n>` | Entry yank tiếp theo |
| `<C-p>` | Entry yank trước |
| `<leader>pi` | Put indent after (linewise) |
| `<leader>pI` | Put indent before (linewise) |

### Session

| Phím | Tác dụng |
|---|---|
| `<leader>qs` | Lưu session |
| `<leader>ql` | Tải session |
| `<leader>qS` | Chọn session từ danh sách |
| `<leader>qd` | Xoá session |
| `<leader>q` | Quit |
| `<leader>Q` | Quit all (force) |

### Treesitter Textobjects

| Phím | Tác dụng |
|---|---|
| `af` / `if` | Around/inside function |
| `ac` / `ic` | Around/inside class |
| `aa` / `ia` | Around/inside argument |
| `al` / `il` | Around/inside loop |
| `ai` / `ii` | Around/inside if |
| `]m` / `[m` | Next/prev function start |
| `]c` / `[c` | Next/prev class |

### Telescope — trong popup

| Phím | Tác dụng |
|---|---|
| `<C-j>` / `<C-k>` | Di chuyển lên/xuống |
| `<C-q>` | Gửi kết quả sang quickfix list |
| `<Esc>` | Đóng |

### Tiện ích khác

| Phím | Tác dụng |
|---|---|
| `<C-s>` | Lưu file |
| `<Esc>` | Xoá search highlight |
| `<A-j>` / `<A-k>` | Di chuyển dòng lên/xuống |
| `]<Space>` / `[<Space>` | Thêm dòng trống bên dưới/trên |
| `Y` | Yank đến cuối dòng |
| `<C-Space>` | Treesitter incremental selection |
| `<leader>?` | Xem keymap buffer (which-key) |

---

## Format on Save

conform.nvim tự động format khi lưu file với các formatter sau:

| Ngôn ngữ | Formatter |
|---|---|
| Lua | stylua |
| Go | goimports → gofmt |
| Python | ruff_format → isort → black |
| JS/TS/JSX/TSX/CSS/HTML | oxfmt → prettier |
| JSON / JSONC | oxfmt → prettier |
| Rust | rustfmt |
| TOML | taplo |
| Markdown | oxfmt → prettier |
| YAML | oxfmt → prettier |

`stop_after_first = true` nghĩa là nếu formatter đầu tiên trong danh sách có sẵn thì dùng luôn, không thử cái sau.

Format không chạy cho file trong `node_modules/` và có thể tắt per-buffer (`FormatDisable!`).

---

## Session Management

Session được lưu theo thư mục làm việc hiện tại (cwd). Khi mở Neovim mà không có file argument, session sẽ **tự động restore** nếu đã từng lưu trước đó.

Session được lưu tại: `~/.local/state/nvim/sessions/`

---

## LSP & Inlay Hints

Inlay hints được bật tự động khi LSP server hỗ trợ, và **tự tắt khi vào insert mode** (để không che text đang gõ). Bật lại ngay khi rời insert mode.

Document color (hiển thị màu inline) cũng được bật nếu LSP server hỗ trợ `textDocument/documentColor`.

---

## Dashboard

Màn hình chào (dashboard-nvim, theme hyper) hiển thị khi mở Neovim không có file:

| Phím | Tác dụng |
|---|---|
| `n` | New file |
| `f` | Find files |
| `r` | Recent files |
| `g` | Live grep |
| `c` | Mở init.lua |
| `q` | Quit |
