#!/usr/bin/env bash
# ~/.config/waybar/scripts/nvim-cheat.sh
# Waybar module: Neovim/LazyVim cheatsheet theo giai đoạn
# Click trái = next stage, Click phải = prev stage, Click giữa = reset

STATE_FILE="/tmp/nvim-cheat-stage"
SIGNAL=8  # phải match với "signal" trong waybar-module.jsonc

# ── Cheatsheet data ──────────────────────────────────────────

STAGES=(
  "1: Cơ bản"
  "2: Text objects"
  "3: LazyVim"
  "4: Dev/LSP"
  "5: Git"
  "6: Nâng cao"
)

ICONS=(
  " 1"
  " 2"
  " 3"
  " 4"
  " 5"
  " 6"
)

read -r -d '' TIP_1 << 'HEREDOC'
━━ Giai đoạn 1: Cơ bản ━━

Di chuyển
  h j k l        trái/xuống/lên/phải
  w / b          nhảy word tới/lui
  e              cuối word
  0 / $          đầu/cuối dòng
  gg / G         đầu/cuối file
  Ctrl+d / u     nửa trang xuống/lên

Chế độ
  i              insert trước cursor
  a              insert sau cursor
  o / O          dòng mới dưới/trên
  Esc / Ctrl+[   về normal mode
  v / V          visual / visual line

Thao tác
  dd             xóa dòng
  yy             copy dòng
  p / P          paste dưới/trên
  x              xóa ký tự
  u / Ctrl+r     undo / redo
  .              lặp lại thao tác

Lưu & thoát
  :w             lưu
  :q             thoát
  :wq / ZZ       lưu & thoát
  :q!            thoát không lưu
HEREDOC

read -r -d '' TIP_2 << 'HEREDOC'
━━ Giai đoạn 2: Text objects ━━

Pattern: {verb}{modifier}{object}
  d = delete  c = change  y = yank
  i = inner   a = around

Ví dụ thực tế
  diw            xóa word (giữ space)
  daw            xóa word + space
  ci"            đổi text trong ""
  ca(            xóa cả cặp ()
  yi{            copy trong {}
  dit            xóa trong HTML tag
  dap            xóa cả paragraph

Motion nâng cao
  f{c} / F{c}   nhảy tới/lui ký tự c
  t{c} / T{c}   nhảy đến trước ký tự c
  ;  /  ,        lặp f/t tới/lui
  %              nhảy cặp ngoặc
  * / #          tìm word dưới cursor
  { / }          nhảy paragraph

Combo hay
  ct)            change đến trước )
  df,            delete đến dấu ,
  vit            select trong tag
  >ap            indent paragraph
HEREDOC

read -r -d '' TIP_3 << 'HEREDOC'
━━ Giai đoạn 3: LazyVim ━━

⌘ Space = leader key (hiện menu)

File & buffer
  Space f f      tìm file (Telescope)
  Space f r      file gần đây
  Space /        grep toàn project
  Space ,        chuyển buffer
  Space b d      đóng buffer

Explorer
  Space e        toggle file tree
  Space E        file tree (root dir)

Window
  Space w        menu window
  Ctrl+h/j/k/l  chuyển window
  Space -        split ngang
  Space |        split dọc

UI
  Space u        menu UI toggles
  Space u w      toggle word wrap
  Space u n      toggle line numbers
  Space u d      toggle diagnostics
HEREDOC

read -r -d '' TIP_4 << 'HEREDOC'
━━ Giai đoạn 4: Dev / LSP ━━

Navigation
  gd             go to definition
  gr             go to references
  gI             go to implementation
  gy             go to type definition
  K              hover documentation
  Ctrl+k         signature help

Actions
  Space c a      code action
  Space c r      rename symbol
  Space c f      format file

Diagnostics
  ]d / [d        diagnostic tới/lui
  Space x x      danh sách diagnostics
  gl             hiện diagnostic dòng

Completion (insert mode)
  Ctrl+n/p       next/prev suggestion
  Ctrl+y         chấp nhận
  Ctrl+e         đóng menu
  Tab            snippet jump next
  Shift+Tab      snippet jump prev

Terminal
  Ctrl+/         toggle terminal
HEREDOC

read -r -d '' TIP_5 << 'HEREDOC'
━━ Giai đoạn 5: Git ━━

LazyVim Git
  Space g g      lazygit (fullscreen)
  Space g f      git file log
  Space g l      git log
  Space g b      git blame line

Gitsigns (in-buffer)
  ]h / [h        hunk tới/lui
  Space g h s    stage hunk
  Space g h r    reset hunk
  Space g h S    stage buffer
  Space g h u    undo stage hunk
  Space g h p    preview hunk
  Space g h d    diff this

Lazygit tips
  Space          stage/unstage file
  c              commit
  P              push
  p              pull
  s              stash
  z              undo last action
HEREDOC

read -r -d '' TIP_6 << 'HEREDOC'
━━ Giai đoạn 6: Nâng cao ━━

Macro
  q{reg}         bắt đầu record macro
  q              dừng record
  @{reg}         chạy macro
  @@             chạy lại macro cuối

Multi-cursor (mini.surround)
  sa{motion}{c}  surround add
  sd{c}          surround delete
  sr{old}{new}   surround replace

Telescope nâng cao
  Space s s      search symbols
  Space s g      grep with args
  Space s k      search keymaps
  Space s h      search help tags

Marks & jumps
  m{a-z}         đặt mark
  '{a-z}         nhảy đến mark
  Ctrl+o / i     jumplist lui/tới
  gf             mở file dưới cursor

Folding
  za             toggle fold
  zR             mở hết folds
  zM             đóng hết folds

:LazyExtras      bật thêm plugins
HEREDOC

TIPS=("$TIP_1" "$TIP_2" "$TIP_3" "$TIP_4" "$TIP_5" "$TIP_6")
TOTAL=${#STAGES[@]}

# ── State management ─────────────────────────────────────────

get_stage() {
  local val
  val=$(cat "$STATE_FILE" 2>/dev/null)
  # validate: phải là số trong range hợp lệ
  if [[ "$val" =~ ^[0-9]+$ ]] && (( val < TOTAL )); then
    echo "$val"
  else
    echo 0
    echo 0 > "$STATE_FILE"  # reset luôn nếu stale
  fi
}

set_stage() {
  echo "$1" > "$STATE_FILE"
}

current=$(get_stage)

case "${1:-}" in
  next)
    current=$(( (current + 1) % TOTAL ))
    set_stage "$current"
    pkill -RTMIN+"$SIGNAL" waybar
    exit 0
    ;;
  prev)
    current=$(( (current - 1 + TOTAL) % TOTAL ))
    set_stage "$current"
    pkill -RTMIN+"$SIGNAL" waybar
    exit 0
    ;;
  reset)
    current=0
    set_stage 0
    pkill -RTMIN+"$SIGNAL" waybar
    exit 0
    ;;
esac

# ── Output JSON for waybar ───────────────────────────────────

tooltip="${TIPS[$current]}"
tooltip="${tooltip//\\/\\\\}"
tooltip="${tooltip//\"/\\\"}"
tooltip="${tooltip//$'\n'/\\n}"

echo "{\"text\": \"${ICONS[$current]}\", \"tooltip\": \"${tooltip}\", \"class\": \"nvim-cheat\"}"
