#!/usr/bin/env python3
# ~/.config/waybar/scripts/nvim-cheat.py
# on-click        → next stage
# on-click-right  → prev stage
# on-click-middle → reset

import json
import sys

STATE_FILE = "/tmp/nvim-cheat-stage"

# ── Stages ───────────────────────────────────────────────────

STAGES = [
    {
        "icon": "󰕷 1",
        "title": "Movement",
        "content": """\
━━ Stage 1: Movement Cơ bản ━━

Di chuyển trong file
  h j k l        trái / xuống / lên / phải
  w / b          nhảy word tới / lui
  e              nhảy cuối word
  0 / $          đầu / cuối dòng
  ^              ký tự đầu tiên không trắng
  gg / G         đầu / cuối file
  {N}G           nhảy dòng N
  <C-d> / <C-u>  nửa trang xuống / lên
  <C-f> / <C-b>  nguyên trang xuống / lên
  n / N          tìm match tới / lui
  * / #          tìm word dưới cursor tới / lui
  { / }          paragraph trước / sau
  %              nhảy tới ngoặc tương ứng

Window + Buffer
  <C-h/j/k/l>    di chuyển giữa windows
  <Tab>          buffer tiếp theo
  <S-Tab>        buffer trước đó
  <leader>x      đóng buffer (Snacks)
  <leader>e      toggle file explorer
  <C-Up/Down>    resize height
  <C-Left/Right> resize width

Chế độ
  i / a          insert trước / sau cursor
  o / O          dòng mới dưới / trên
  v / V          visual char / visual line
  <C-v>          visual block (chọn cột)
  Esc            về normal mode + xóa highlight

Thao tác cơ bản
  dd             xóa dòng
  yy             copy dòng
  Y              copy đến cuối dòng
  p / P          paste dưới / trên
  x              xóa ký tự
  r{c}           thay ký tự bằng c
  u / <C-r>      undo / redo
  .              lặp lại thao tác
  J              nối dòng dưới
  <A-j> / <A-k>  di chuyển dòng xuống / lên
  ]<Space>       thêm dòng trống bên dưới
  [<Space>       thêm dòng trống bên trên

Lưu + thoát
  <C-s>          lưu (normal + insert mode)
  <leader>Q      thoát tất cả (force)""",
    },
    {
        "icon": "󰕷 2",
        "title": "LSP + Search",
        "content": """\
━━ Stage 2: LSP + Search + Picker ━━

LSP (Code Intelligence)
  gd             go to definition
  gD             go to declaration
  gr             go to references
  gi             go to implementation
  grt            go to type definition
  K              hover documentation
  <leader>cr     rename symbol
  <leader>ca     code action
  <leader>cl     LSP fix all (oxlint / eslint)
  <leader>cf     format buffer (Conform)
  <leader>ls     signature help

Diagnostics
  <leader>cd     hiện diagnostics dòng hiện tại
  ]d / [d        diagnostic tiếp / trước
  ]e / [e        error tiếp / trước
  ]w / [w        warning tiếp / trước

Picker (Snacks)
  <leader>ff     tìm file theo tên
  <leader>/      live grep trong project
  <leader>fg     live grep
  <leader>fb     danh sách buffers
  <leader>fo     recent files
  <leader>fs     document symbols
  <leader>fS     workspace symbols
  <leader>fd     diagnostics picker
  <leader>gc     git commits
  <leader>gs     git status
  <leader>sr     search & replace (grug-far)

Text Objects
  diw / daw      xóa word (inner / around)
  ci" / ca"      change trong / kể cả dấu nháy
  ci( / ca(      change trong / kể cả ngoặc
  yi{ / ya{      copy trong / kể cả ngoặc nhọn
  vip            select paragraph

Motion nâng cao
  s              jump theo label (nvim-jump)
  f{c} / F{c}    nhảy tới / lui ký tự c
  t{c} / T{c}    nhảy trước / sau ký tự c
  ; / ,          lặp f/t theo chiều
  <C-o> / <C-i>  jumplist lui / tới

Vim Tips
  *              search word dưới cursor
  #              search ngược
  ~              toggle hoa/thường
  .              lặp lại thao tác vừa rồi
  m{a-z}         đặt mark (local)
  '{mark}        nhảy đến mark
  q{reg}         record macro
  @{reg}         chạy macro""",
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
