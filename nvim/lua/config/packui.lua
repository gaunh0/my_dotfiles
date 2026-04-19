-- PackUI — minimal TUI for vim.pack (built-in package manager)
-- :Pack  →  open the manager window
-- Keys inside the window:
--   U  — update all plugins
--   u  — update plugin under cursor
--   D  — delete plugin under cursor (removes the pack directory)
--   L  — load plugin under cursor (packadd)
--   q  — close

local M = {}

local BUF, WIN

local function close()
  if WIN and vim.api.nvim_win_is_valid(WIN) then
    vim.api.nvim_win_close(WIN, true)
  end
  if BUF and vim.api.nvim_buf_is_valid(BUF) then
    vim.api.nvim_buf_delete(BUF, { force = true })
  end
  BUF, WIN = nil, nil
end

local function pack_list()
  local ok, packs = pcall(vim.pack.get)
  if not ok or not packs then return {} end
  return packs
end

local function render(buf, packs)
  local lines = { " vim.pack — Plugin Manager", " ──────────────────────────────────────────", "" }
  local loaded   = {}
  local unloaded = {}

  for _, p in ipairs(packs) do
    if p.active then
      table.insert(loaded, p)
    else
      table.insert(unloaded, p)
    end
  end

  table.insert(lines, " ● Loaded (" .. #loaded .. ")")
  for _, p in ipairs(loaded) do
    local label = "   " .. (p.spec and p.spec.name or "?")
    table.insert(lines, label)
  end

  table.insert(lines, "")
  table.insert(lines, " ○ Not loaded (" .. #unloaded .. ")")
  for _, p in ipairs(unloaded) do
    local label = "   " .. (p.spec and p.spec.name or "?")
    table.insert(lines, label)
  end

  table.insert(lines, "")
  table.insert(lines, " [U] update all  [u] update  [D] delete  [L] load  [q] close")

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
end

local function refresh()
  if not BUF or not vim.api.nvim_buf_is_valid(BUF) then return end
  render(BUF, pack_list())
end

local function plugin_at_cursor()
  local line  = vim.api.nvim_get_current_line():match("^%s+(.-)%s*$")
  if not line or line == "" then return nil end
  local packs = pack_list()
  for _, p in ipairs(packs) do
    local name = p.spec and p.spec.name
    if name == line then return p end
  end
  return nil
end

function M.open()
  if WIN and vim.api.nvim_win_is_valid(WIN) then
    vim.api.nvim_set_current_win(WIN)
    return
  end

  BUF = vim.api.nvim_create_buf(false, true)
  vim.bo[BUF].buftype    = "nofile"
  vim.bo[BUF].bufhidden  = "wipe"
  vim.bo[BUF].swapfile   = false
  vim.bo[BUF].filetype   = "packui"
  vim.bo[BUF].modifiable = false

  local width  = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines   * 0.6)
  local row    = math.floor((vim.o.lines   - height) / 2)
  local col    = math.floor((vim.o.columns - width)  / 2)

  WIN = vim.api.nvim_open_win(BUF, true, {
    relative = "editor",
    row = row, col = col,
    width = width, height = height,
    style  = "minimal",
    border = "rounded",
    title  = " Pack ",
    title_pos = "center",
  })

  render(BUF, pack_list())

  local opts = { buffer = BUF, nowait = true, silent = true }

  vim.keymap.set("n", "q", close, vim.tbl_extend("force", opts, { desc = "Close" }))
  vim.keymap.set("n", "<Esc>", close, vim.tbl_extend("force", opts, { desc = "Close" }))

  vim.keymap.set("n", "U", function()
    close()
    vim.cmd("Pack update")
  end, vim.tbl_extend("force", opts, { desc = "Update all" }))

  vim.keymap.set("n", "u", function()
    local p = plugin_at_cursor()
    if p and p.spec then
      close()
      vim.cmd("Pack update " .. vim.fn.shellescape(p.spec.name))
    end
  end, vim.tbl_extend("force", opts, { desc = "Update plugin" }))

  vim.keymap.set("n", "L", function()
    local p = plugin_at_cursor()
    if p and p.name and not p.active then
      pcall(vim.cmd.packadd, p.name)
      refresh()
    end
  end, vim.tbl_extend("force", opts, { desc = "Load plugin" }))

  vim.keymap.set("n", "D", function()
    local p = plugin_at_cursor()
    if not p then return end
    local name = p.spec and p.spec.name or "?"
    vim.ui.input({ prompt = "Delete " .. name .. "? [y/N] " }, function(answer)
      if answer and answer:lower() == "y" then
        -- vim.pack doesn't expose a delete API yet; show a hint
        vim.pack.del(p.spec.src or p.spec.name)
        refresh()
      end
    end)
  end, vim.tbl_extend("force", opts, { desc = "Delete plugin" }))
end

vim.api.nvim_create_user_command("Pack", function()
  M.open()
end, { desc = "Open pack manager UI" })

return M
