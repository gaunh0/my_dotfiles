local M = {}

function M.setup()
  local tabline_str = ""
  local current_buf = vim.fn.bufnr()
  local buf_count = vim.fn.bufnr("$")
  
  -- Loop through all buffers
  for buf_num = 1, buf_count do
    -- Only show listed buffers
    if vim.fn.buflisted(buf_num) == 1 then
      -- Get buffer name
      local buf_name = vim.fn.bufname(buf_num)
      if buf_name == "" then
        buf_name = "  [No Name]"
      else
        buf_name = vim.fn.fnamemodify(buf_name, ":t")
        
        -- Add icons based on file type
        local icon = M.get_file_icon(buf_name)
        buf_name = icon .. " " .. buf_name
      end
      
      -- Check if modified
      local is_modified = vim.fn.getbufvar(buf_num, "&modified")
      local modified_indicator = ""
      if is_modified == 1 then
        modified_indicator = " ●"  -- Dot for modified
      end
      
      -- Highlight current buffer
      if buf_num == current_buf then
        -- Active tab: bright, colorful
        tabline_str = tabline_str .. "%#TabLineSel#"
      else
        -- Inactive tab: dimmer
        tabline_str = tabline_str .. "%#TabLine#"
      end
      
      -- Add buffer to tabline
      tabline_str = tabline_str .. " " .. buf_num .. ":" .. buf_name .. modified_indicator .. " "
    end
  end
  
  -- Fill rest with TabLineFill
  tabline_str = tabline_str .. "%#TabLineFill#%="
  
  return tabline_str
end

-- File type icons (customize these!)
function M.get_file_icon(filename)
  local ext = filename:match("%.([^.]+)$") or ""
  
  local icons = {
    -- Languages
    lua = "🌙",
    py = "🐍",
    js = "📜",
    ts = "📘",
    tsx = "⚛️",
    jsx = "⚛️",
    go = "🔵",
    rs = "🦀",
    rb = "💎",
    java = "☕",
    cpp = "⚙️",
    c = "⚙️",
    h = "🔧",
    
    -- Config & Data
    json = "{}",
    yaml = "⚙️",
    yml = "⚙️",
    xml = "📋",
    toml = "📦",
    
    -- Web
    html = "🌐",
    css = "🎨",
    scss = "🎨",
    sass = "🎨",
    less = "🎨",
    
    -- Documents
    md = "📝",
    txt = "📄",
    pdf = "📕",
    
    -- Shell & Scripts
    sh = "🔧",
    bash = "🔧",
    zsh = "🔧",
    
    -- Docker & DevOps
    dockerfile = "🐳",
    docker = "🐳",
    
    -- Version Control
    gitignore = "📦",
    git = "📦",
    
    -- Vim
    vim = "💚",
    
    -- Directories (shown as [Dir])
    directory = "📁",
  }
  
  -- Check by extension
  if icons[ext] then
    return icons[ext]
  end
  
  -- Check by filename
  if icons[filename:gsub("%..+$", "")] then
    return icons[filename:gsub("%..+$", "")]
  end
  
  -- Default icon
  return "📄"
end

return M

