-- lualine.lua

local lualine = require('lualine')

-- Color table for highlights
local colors = {
  bg       = '#202328',
  fg       = '#ffffff',
  yellow   = '#ECBE7B',
  cyan     = '#12b38e',
  darkblue = '#081633',
  green    = '#AAD364',
  orange   = '#ff360f',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#21d1ff',
  red      = '#c8102e',
}

local mode_colors = {
  n = colors.red,
  i = colors.cyan,
  v = colors.magenta,
  [''] = colors.blue,
  V = colors.blue,
  c = colors.magenta,
  no = colors.red,
  s = colors.orange,
  S = colors.orange,
  [''] = colors.orange,
  ic = colors.yellow,
  R = colors.violet,
  Rv = colors.violet,
  cv = colors.red,
  ce = colors.red,
  r = colors.cyan,
  rm = colors.cyan,
  ['r?'] = colors.cyan,
  ['!'] = colors.red,
  t = colors.red,
}

local filename_mode_colors = {
  n = colors.yellow,
  i = colors.orange,
  v = colors.blue,
  [''] = colors.violet,
}

local dynamic_theme = {
  normal = { c = { fg = colors.fg, bg = colors.bg } },
  inactive = { c = { fg = colors.fg, bg = colors.bg } },
}

local function update_theme_bg()
  local mode = vim.fn.mode()
  local color = mode_colors[mode] or colors.bg
  dynamic_theme.normal.c.bg = color
  dynamic_theme.inactive.c.bg = color
  lualine.setup(config)
end

vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  callback = function()
    vim.schedule(update_theme_bg)
  end,
})

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

config = {
  options = {
    component_separators = '',
    section_separators = '',
    theme = dynamic_theme,
    disabled_filetypes = { "alpha", "dashboard" },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  extensions = { 'nvim-tree' },
}

local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

local function ins_z(component)
  table.insert(config.sections.lualine_z, component)
end

-- Mode text (" N", " I", etc.)
ins_left {
  function()
    local mode_map = {
      n = ' N',
      i = ' I',
      v = ' V',
      [''] = 'VB',
      V = ' V',
    }
    return mode_map[vim.fn.mode()] or ' ?'
  end,
  color = { fg = colors.fg, gui = 'bold' },
  padding = { left = 0, right = 1 },
}

-- Filename with dynamic color
ins_left {
  'filename',
  cond = conditions.buffer_not_empty,
  color = function()
    return { fg = filename_mode_colors[vim.fn.mode()] or colors.magenta, gui = 'bold' }
  end,
}

-- Diagnostics
ins_left {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  sections = { 'error', 'warn' },
  symbols = { error = ' ', warn = ' ' },
  colored = true,
  update_in_insert = false,
  always_visible = true,
  cond = function()
    return vim.bo.filetype ~= "markdown"
  end,
  diagnostics_color = {
    error = { fg = colors.red },
    warn = { fg = colors.yellow },
  },
}

-- Separator
ins_left {
  function() return '%=' end,
}

-- LSP Client Name
ins_right {
  function()
    local msg = 'No Active Lsp'
    local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then return msg end
    for _, client in ipairs(clients) do
      if client.config.filetypes and vim.fn.index(client.config.filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = ' LSP:',
  color = { fg = '#ffffff', gui = 'bold' },
}

-- Encoding
ins_right {
  'o:encoding',
  fmt = string.upper,
  cond = conditions.hide_in_width,
  color = { fg = colors.green, gui = 'bold' },
}

-- File format
ins_right {
  'fileformat',
  fmt = string.upper,
  icons_enabled = false,
  color = { fg = colors.green, gui = 'bold' },
}

-- Git branch
ins_right {
  'branch',
  icon = '',
  color = { fg = colors.violet, gui = 'bold' },
}

-- Git diff
ins_right {
  'diff',
  symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
}

-- Final filler/icon
ins_right {
  function() return '▊' end,
  color = { fg = colors.blue },
  padding = { left = 1 },
}

-- Hourglass Progress
ins_z {
  function()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local chars = { "", "", "" }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
    return chars[index] .. " " .. math.floor(line_ratio * 100) .. "%%"
  end,
  color = { fg = colors.fg, gui = 'bold' },
}

-- Initialize
lualine.setup(config)
update_theme_bg()
