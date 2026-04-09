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
  ^              ký tự đầu tiên
  gg / G         đầu / cuối file
  {N}G           nhảy dòng N
  Ctrl+d / u     nửa trang xuống / lên
  Ctrl+f / b     nguyên trang xuống / lên
  n / N          tìm match tới / lui
  * / #          tìm word dưới cursor tới / lui
  { / }          paragraph trước / sau
  % / ( ) [ ]    match ngoặc tương ứng

Window + Buffer
  <C-h/j/k/l>    di chuyển giữa windows
  <C-n>          buffer tiếp theo
  <C-p>          buffer trước đó
  <C-w>          đóng buffer
  <C-b>          toggle file explorer
  <C-Up/Down>    resize height
  <C-Left/Right> resize width
  <leader>-      split ngang
  <leader>|      split dọc

Chế độ
  i / a          insert trước / sau cursor
  o / O          dòng mới dưới / trên
  v / V          visual char / visual line
  Shift+v        visual line
  Ctrl+v         visual block (chọn cột)
  Esc            về normal mode

Thao tác cơ bản
  dd             xóa dòng
  yy             copy dòng
  p / P          paste dưới / trên
  x              xóa ký tự
  r{c}           thay ký tự bằng c
  u / Ctrl+r     undo / redo
  .              lặp lại thao tác
  J              nối dòng dưới

Lưu + thoát
  <leader>w      lưu
  <leader>q      thoát
  <leader>qa     thoát tất cả""",
    },
    {
        "icon": "󰕷 2",
        "title": "Keywords",
        "content": """\
━━ Stage 2: Keywords + LSP + Search ━━

LSP (Code Intelligence)
  gd             go to definition
  gr             go to references
  gi             go to implementation
  K              hover documentation
  <leader>rn     rename symbol
  <leader>ca     code action
  <leader>f      format code
  [d / ]d        error trước / sau

Tìm + Replace
  /pattern       tìm trong file
  <leader>/      tìm trong project (Telescope)
  <leader>ff     tìm file theo tên
  <leader>sr     search & replace
  n / N          match tiếp / trước

Text Objects & Edit
  diw / daw      xóa word (inner / around)
  ci" / ca"      change trong / kể cả dấu nháy
  ci( / ca(      change trong / kể cả ngoặc
  yi{ / ya{      copy trong / kể cả ngoặc nhọn
  vip            select paragraph

Motion nâng cao
  f{c} / F{c}    nhảy tới / lui ký tự c
  t{c} / T{c}    nhảy trước / sau ký tự c
  ; / ,          lặp f/t theo chiều
  Ctrl+o / i     jumplist lui / tới
  H / L          đầu / cuối dòng

Diff + Undo + Git
  <leader>dd     enable diff
  <leader>do     disable diff
  <leader>u1/2/3 undo 1min / 10min / 1hour
  <leader>/      tìm file / commit trong git

File + Explorer (<C-b>)
  H              go up directory
  h              close explorer
  l              open file/directory
  .              toggle hidden files
  R              rename
  D              delete

Terminal + Tools
  <leader>ff     find files
  <leader>/      grep (search all files)
  gd / gr / K    jump definition / references / hover
  [d / ]d        next / prev diagnostic

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
