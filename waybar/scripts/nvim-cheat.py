#!/usr/bin/env python3
# ~/.config/waybar/scripts/nvim-cheat.py
# on-click        → next stage (next)
# on-click-right  → prev stage (prev)
# on-click-middle → reset

import json
import sys

STATE_FILE = "/tmp/nvim-cheat-stage"

# ── Stages ───────────────────────────────────────────────────

STAGES = [
    {
        "icon": "󰕷 1",
        "title": "Cơ bản",
        "content": """\
━━ Giai đoạn 1: Cơ bản ━━

Di chuyển
  h j k l        trái / xuống / lên / phải
  w / W          nhảy tới đầu word (W = WORD)
  b / B          nhảy lui đầu word
  e / E          nhảy tới cuối word
  ge             nhảy lui cuối word
  0 / ^          đầu dòng / ký tự đầu tiên
  $              cuối dòng
  gg / G         đầu / cuối file
  {N}G           nhảy đến dòng N
  Ctrl+d / u     nửa trang xuống / lên
  Ctrl+f / b     nguyên trang xuống / lên
  zz / zt / zb   căn cursor: giữa / trên / dưới

Chế độ
  i / I          insert trước cursor / đầu dòng
  a / A          insert sau cursor / cuối dòng
  o / O          dòng mới dưới / trên
  s / S          xóa char rồi insert / xóa dòng rồi insert
  R              replace mode (ghi đè)
  Esc / Ctrl+c   về normal mode
  v / V          visual char / visual line
  Ctrl+v         visual block (chọn cột)

Thao tác
  dd / {n}dd     xóa dòng / xóa n dòng
  yy / {n}yy     copy dòng / copy n dòng
  p / P          paste dưới / trên cursor
  x / X          xóa char sau / trước cursor
  r{c}           replace char bằng c
  ~              đổi hoa/thường
  u / Ctrl+r     undo / redo
  .              lặp lại thao tác vừa rồi
  J              nối dòng dưới vào dòng hiện tại

Lưu + thoát
  :w             lưu
  :wq / ZZ       lưu + thoát
  :q!            thoát không lưu
  :wa / :xa      lưu / lưu+thoát tất cả buffers""",
    },
    {
        "icon": "󰕷 2",
        "title": "Text objects",
        "content": """\
━━ Giai đoạn 2: Text objects ━━

Pattern: {verb}{scope}{object}
  verb    d=delete  c=change  y=yank  v=select  >=indent
  scope   i=inner   a=around
  object  w=word  W=WORD  s=sentence  p=paragraph
          " ' ` ( ) [ ] { } < >  t=tag  b=block

Combo thực tế
  diw / daw      xóa word, giữ space / xóa luôn space
  ci" / ca"      change trong / kể cả dấu nháy
  ci( / ca(      change trong / kể cả dấu ngoặc
  yi{ / ya{      copy trong / kể cả dấu ngoặc nhọn
  dit / dat      xóa trong / kể cả HTML tag
  dap / yap      xóa / copy cả paragraph
  vip            select cả paragraph
  =ip            auto-indent paragraph

Motion nâng cao
  f{c} / F{c}    nhảy tới / lui đến ký tự c (trên dòng)
  t{c} / T{c}    nhảy đến trước / sau ký tự c
  ; / ,          lặp f/t theo chiều tới / lui
  %              nhảy đến cặp ngoặc tương ứng
  * / #          tìm word dưới cursor tới / lui
  { / }          nhảy paragraph trước / sau
  [[ / ]]        nhảy function/section trước / sau

Combo nâng cao
  ct)            change mọi thứ đến trước )
  df,            delete đến và kể cả dấu ,
  d/foo          delete đến trước từ "foo"
  vit            select nội dung trong tag
  >ap / <ap      indent / dedent paragraph
  gUiw / guiw    UPPER / lower cả word
  g~iw           toggle case cả word""",
    },
    {
        "icon": "󰕷 3",
        "title": "LazyVim",
        "content": """\
━━ Giai đoạn 3: LazyVim ━━

Space = leader key

File + Search
  Space f f      tìm file (Telescope)
  Space f r      file gần đây
  Space f g      tìm file trong git
  Space f n      file mới
  Space /        grep toàn project
  Space s w      grep word dưới cursor
  Space s r      search + replace (Spectre)
  Space s s      search symbols (LSP)

Buffer
  Space ,        chuyển buffer (fuzzy)
  Space b b      chọn buffer
  Space b d      đóng buffer hiện tại
  Space b D      đóng buffer + window
  Space b l      đóng các buffer bên trái
  Space b r      đóng các buffer bên phải
  [b / ]b        buffer trước / sau

Explorer (neo-tree)
  Space e        toggle file tree (root)
  Space E        toggle file tree (cwd)
  Space f e      focus file tree

Window
  Space w        menu window
  Ctrl+h/j/k/l   di chuyển giữa windows
  Space -        split ngang
  Space |        split dọc
  Space w d      đóng window
  Space w m      maximize window toggle

Tab
  Space Tab Tab  chuyển tab
  Space Tab n    tab mới
  Space Tab d    đóng tab
  [Tab / ]Tab    tab trước / sau

UI toggles
  Space u l      toggle line numbers
  Space u L      toggle relative numbers
  Space u w      toggle word wrap
  Space u s      toggle spelling
  Space u d      toggle diagnostics
  Space u T      toggle treesitter highlight
  Space u f      toggle autoformat (buffer)
  Space u F      toggle autoformat (global)""",
    },
    {
        "icon": "󰕷 4",
        "title": "Dev / LSP",
        "content": """\
━━ Giai đoạn 4: Dev / LSP ━━

Navigation
  gd             go to definition
  gD             go to declaration
  gr             go to references
  gI             go to implementation
  gy             go to type definition
  K              hover docs (nhấn 2 lần để vào float)
  Ctrl+k         signature help (insert mode)
  gf             mở file dưới cursor
  [[ / ]]        function trước / sau

Code actions
  Space c a      code action
  Space c r      rename symbol
  Space c f      format file/selection
  Space c d      line diagnostics float
  Space c l      run codelens

Diagnostics
  ]d / [d        diagnostic tới / lui
  ]e / [e        error tới / lui
  ]w / [w        warning tới / lui
  Space x x      danh sách diagnostics (Trouble)
  Space x l      location list
  Space x q      quickfix list
  Space x w      workspace diagnostics

Completion (insert mode)
  Ctrl+n / p     next / prev suggestion
  Ctrl+y         chấp nhận suggestion
  Ctrl+e         đóng completion menu
  Tab            snippet jump next / expand
  Shift+Tab      snippet jump prev
  Ctrl+b / f     scroll docs lên / xuống

Terminal
  Ctrl+/         toggle terminal float
  Space f t      terminal (root)
  Space f T      terminal (cwd)

Quickfix
  ]q / [q        quickfix tới / lui
  Space c s      document symbols
  Space c S      workspace symbols""",
    },
    {
        "icon": "󰕷 5",
        "title": "Git",
        "content": """\
━━ Giai đoạn 5: Git ━━

LazyVim Git
  Space g g      lazygit (fullscreen)
  Space g G      lazygit (cwd)
  Space g f      git file log
  Space g l      git log
  Space g b      git blame line
  Space g B      git browse (open in browser)
  Space g s      git status (Telescope)
  Space g C      git commits (Telescope)

Gitsigns (in-buffer)
  ]h / [h        hunk tới / lui
  Space g h s    stage hunk
  Space g h S    stage toàn buffer
  Space g h r    reset hunk
  Space g h R    reset toàn buffer
  Space g h u    undo stage hunk
  Space g h p    preview hunk inline
  Space g h d    diff this (so với index)
  Space g h D    diff this (so với HEAD)
  Space g h b    blame dòng (full)
  ih             text object: select hunk

Lazygit tips
  Space          stage / unstage file
  a              stage tất cả
  c / C          commit / commit với message
  A              amend commit cuối
  P / p          push / pull
  f              fetch
  s / S          stash / stash tất cả
  z              undo last action
  e              mở file trong editor
  Enter          xem diff của file""",
    },
    {
        "icon": "󰕷 6",
        "title": "Nâng cao",
        "content": """\
━━ Giai đoạn 6: Nâng cao ━━

Macro
  q{reg}         bắt đầu record macro vào register
  q              dừng record
  @{reg}         chạy macro từ register
  @@             chạy lại macro cuối
  {n}@{reg}      chạy macro n lần
  :norm @{reg}   chạy macro trên dòng được visual chọn

mini.surround
  sa{motion}{c}  thêm surround   — saiw" → "word"
  sd{c}          xóa surround    — sd" → bỏ dấu "
  sr{old}{new}   thay surround   — sr"' → đổi " thành '
  sf / sF        tìm surround phải / trái
  sh{c}          highlight surround

Marks + Jumps
  m{a-z}         đặt mark local (trong file)
  m{A-Z}         đặt mark global (cross-file)
  '{mark}        nhảy đến đầu dòng của mark
  Ctrl+o / i     jumplist lui / tới
  :marks         xem tất cả marks

Folding
  za / zA        toggle fold / toggle fold + nested
  zo / zc        mở / đóng fold
  zR / zM        mở hết / đóng hết tất cả folds
  zj / zk        nhảy fold dưới / trên

Search + Replace
  :%s/old/new/g  replace toàn file
  :%s/old/new/gc replace có confirm từng cái
  Space s r      Spectre: search + replace toàn project
  cgn            change match → dùng . để lặp tiếp

Registers
  "{reg}y / p    yank / paste vào/từ register
  "0             yank register (không bị dd overwrite)
  "+             clipboard hệ thống
  :reg           xem tất cả registers

Quản lý
  :LazyExtras    bật thêm plugins
  :Lazy          quản lý plugins
  :Mason         quản lý LSP / linters / formatters
  :checkhealth   kiểm tra sức khỏe Neovim""",
    },
]

TOTAL = len(STAGES)

# ── State ────────────────────────────────────────────────────


def get_state() -> int:
    try:
        val = int(open(STATE_FILE).read().strip())
        return val if 0 <= val < TOTAL else 0
    except (FileNotFoundError, ValueError, OSError):
        return 0


def set_state(val: int):
    with open(STATE_FILE, "w") as f:
        f.write(str(val))


# ── Main ─────────────────────────────────────────────────────

current = get_state()
action = sys.argv[1] if len(sys.argv) > 1 else None

if action in (">>", "next"):
    current = (current + 1) % TOTAL
elif action in ("<<", "prev"):
    current = (current - 1 + TOTAL) % TOTAL
elif action == "reset":
    current = 0

set_state(current)

stage = STAGES[current]

print(
    json.dumps(
        {
            "text": stage["icon"],
            "tooltip": stage["content"]
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;"),
            "class": f"nvim-cheat stage-{current + 1}",
        },
        ensure_ascii=False,
    )
)
