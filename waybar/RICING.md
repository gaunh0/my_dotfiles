# Rice Waybar — HDSD

## Cấu trúc file

```
~/.config/waybar/
├── config.jsonc        # layout, modules
├── style.css           # styling
└── colors/
    └── colors.css      # color tokens (@primary, @error, ...)
```

---

## Cách CSS này hoạt động

### 1. Token màu — `colors/colors.css`

File này dùng GTK CSS custom properties (`@define-color`). Waybar chạy trên GTK3,
nên cú pháp khác với CSS web (`var(--x)` không dùng được):

```css
@define-color background            #0f0f0f;
@define-color surface_container_highest #2e2e2e;
@define-color outline_variant       #303030;
@define-color primary               #ffffff;
@define-color on_primary            #0f0f0f;
@define-color warning               #f0c04a;
@define-color error                 #f28b82;
```

`style.css` nạp file này bằng:

```css
@import url("./colors/colors.css");
```

Sau đó dùng token bằng ký hiệu `@tên`:

```css
background: @surface_container_highest;
color: @primary;
```

**Tên token theo Material Design 3** — mỗi tên có nghĩa rõ ràng:

| Token | Vai trò |
|---|---|
| `@background` | Nền thanh bar |
| `@on_background` | Chữ/icon trên nền bar |
| `@surface` | Nền tooltip |
| `@on_surface` | Chữ trong tooltip |
| `@surface_container_highest` | Nền "ô bao" module (hơi sáng hơn background) |
| `@outline_variant` | Nền hover, workspace dot không active |
| `@primary` | Highlight khi connected/active — trắng |
| `@on_primary` | Chữ trên nền @primary |
| `@warning` | Màu cảnh báo (pin sắp hết) |
| `@error` | Màu lỗi / nguy hiểm (pin crit, nút power) |

---

### 2. Transition toàn cục

```css
* {
    transition: 150ms;
}
```

Áp lên mọi element — khi hover đổi `background`, hiệu ứng fade 150ms tự động.
Không cần viết `transition` riêng cho từng module.

---

### 3. Layout bar

```css
#waybar {
    background: @background;   /* nền đen #0f0f0f */
    color: @on_background;     /* chữ mặc định #e3e3e3 */
}

.modules-right.horizontal {
    margin-right: 4px;         /* tránh module sát mép phải màn hình */
}
```

---

### 4. Workspace dots — pill animation

```css
#workspaces button {
    font-size: 0px;        /* ẩn text số, chỉ hiện hình */
    min-width: 8px;
    min-height: 0px;
    padding: 0;
    margin: 7px 4px;
    border-radius: 1rem;   /* viên thuốc tròn */
    background: @outline_variant;  /* dot xám mờ = inactive */
}

#workspaces button.active {
    background: @on_background;    /* trắng = active */
    min-width: 2rem;               /* kéo dài ra → pill dài hơn */
    margin: 7px 0.3rem;
}
```

`transition: 150ms` từ rule `*` làm cho dot **trượt từ tròn sang pill** khi đổi workspace.
Không cần JS, chỉ thay đổi `min-width` là GTK tự animate.

---

### 5. Pattern "ô bao" cho module

Tất cả module chính dùng một block CSS chung thay vì lặp lại:

```css
#clock,
#network,
#bluetooth,
#battery,
#backlight,
#pulseaudio,
#custom-power,
#custom-sysmon {
    background: @surface_container_highest;  /* #2e2e2e — hơi sáng hơn bar */
    border-radius: 6px;
    margin: 2px 2px;
    padding: 0 10px;
    font-family: sans-serif;
    font-weight: bold;
    font-size: 14px;
    letter-spacing: 0.1em;
}
```

Hover block tương tự — đổi background sang `@outline_variant` (tối hơn một chút):

```css
#clock:hover,
... {
    background: @outline_variant;   /* #303030 */
}
```

Hiệu ứng: module nhạt lên khi hover, tối đi khi bỏ chuột ra.

---

### 6. Override cho module cụ thể

Sau block chung, có thể override từng module mà không cần viết lại toàn bộ:

```css
/* Network và Pulseaudio có icon dài hơn → thêm padding */
#network,
#pulseaudio {
    padding: 0 1rem 0 0.6rem;
}

/* Custom-power: không có ô bao, chỉ icon đỏ */
#custom-power {
    background: none;   /* ghi đè block chung */
    color: @error;
    font-size: 16px;
    padding: 0 8px;
}

/* Hover mới tạo ô bao */
#custom-power:hover {
    background: @surface_container_highest;
}
```

---

### 7. Highlight theo trạng thái (state classes)

Waybar tự động gắn CSS class vào module theo trạng thái. Override màu ở đây:

```css
/* Network kết nối → đổi sang @primary (trắng) với chữ đen */
#network.wifi,
#network.ethernet,
#network.linked {
    background: @primary;
    color: @background;   /* chữ đen để đọc được trên nền trắng */
}

/* Bluetooth đang kết nối → tương tự */
#bluetooth.connected {
    background: @primary;
    color: @background;
}

/* Battery cảnh báo — chỉ đổi màu chữ, giữ nguyên ô bao */
#battery.warning  { color: @warning; }
#battery.critical { color: @error;   }
```

---

### 8. Tooltip của nvim-cheat

Module `custom-nvim-cheat` dùng tooltip GTK để hiện cheatsheet:

```css
/* Kích thước tooltip đủ rộng cho bảng cheatsheet */
#custom-nvim-cheat tooltip {
    background: @surface;
    border: 1px solid @outline_variant;
    border-radius: 8px;
    min-width: 1200px;
}

/* Force monospace — GTK hay kế thừa font sans-serif từ parent */
tooltip,
tooltip *,
tooltip label,
window.background.tooltip,
window.background.tooltip * {
    font-family: "JetBrainsMono Nerd Font", monospace;
    font-size: 12px;
    font-weight: normal;
}
```

Cần selector redundant (`tooltip`, `tooltip *`, `window.background.tooltip *`) vì
GTK CSS specificity hoạt động khác web — parent styles không luôn kế thừa xuống
tooltip window do tooltip là GTK popup riêng.

---

## Cách mượn config từ người khác

1. Copy file `style.css` của họ vào `style.css_2` (hoặc tên bất kỳ)
2. Đọc và so sánh — tập trung vào **triết lý khác nhau**:
   - Token-based vs hardcode màu
   - Pill (`border-radius: 1rem`) vs square (`border-radius: 6px`)
   - Colorful vs minimal
3. Chỉ lấy **pattern** cụ thể, không copy nguyên file

---

## Reload waybar

```bash
pkill waybar && waybar &
```
