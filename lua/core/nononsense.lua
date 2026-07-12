local M = {}

local palette = {
  alt = "#a66b5f",
  alt_bg = "#1a1715",
  bg = "#000000",
  comment = "#54504a",
  constant = "#c8c093",
  fg = "#d4ceb2",
  func = "#a6a08a",
  keyword = "#b07968",
  line = "#000000",
  number = "#b98b6f",
  operator = "#8f8776",
  property = "#c8c093",
  string = "#dcd7ba",
  type = "#76a297",
  visual = "#2f2923",
  diag_red = "#b86f68",
  diag_blue = "#8a9891",
  diag_yellow = "#b98b6f",
  diag_green = "#76a297",
}

local defaults = {
  variant = 1,
  alt_background = false,
  transparent = false,
  dim_inactive = false,
  italic_comments = true,
  terminal_colors = true,
  overrides = {},
}

local options = vim.deepcopy(defaults)

local function merge(user_options)
  options = vim.tbl_deep_extend("force", vim.deepcopy(defaults), user_options or {})
end

local function colors()
  local c = vim.deepcopy(palette)
  if options.alt_background then
    c.bg = c.alt_bg
    c.line = c.alt_bg
  end
  if options.transparent then
    c.bg = "NONE"
    c.line = "NONE"
  end
  return c
end

local function global_options()
  local result = {}
  local map = {
    variant = "nononsense_variant",
    alt_background = "nononsense_alt_background",
    transparent = "nononsense_transparent",
    dim_inactive = "nononsense_dim_inactive",
    italic_comments = "nononsense_italic_comments",
    terminal_colors = "nononsense_terminal_colors",
  }

  for option, name in pairs(map) do
    if vim.g[name] ~= nil then
      result[option] = vim.g[name]
    end
  end

  return result
end

local function set(group, spec)
  vim.api.nvim_set_hl(0, group, spec)
end

local function link(group, target)
  set(group, { link = target })
end

local function apply_terminal(c)
  local terminal = {
    c.alt_bg,
    c.diag_red,
    c.diag_green,
    c.func,
    c.constant,
    c.keyword,
    c.string,
    c.fg,
    c.comment,
    c.diag_red,
    c.property,
    c.number,
    c.diag_blue,
    c.type,
    c.alt,
    c.fg,
  }

  for index, color in ipairs(terminal) do
    vim.g["terminal_color_" .. (index - 1)] = color
  end
end

local function apply_highlights(c)
  local bg = c.bg
  local none = "NONE"
  local float_bg = options.transparent and none or c.alt_bg
  local gutter_bg = none
  local cursorline = options.transparent and none or c.alt_bg

  set("Normal", { fg = c.fg, bg = bg })
  set("NormalNC", { fg = c.fg, bg = options.dim_inactive and c.alt_bg or bg })
  set("NormalFloat", { fg = c.fg, bg = "NONE" })
  set("FloatBorder", { fg = c.comment, bg = "NONE" })
  set("FloatTitle", { fg = c.keyword, bg = "NONE", bold = true })
  set("ColorColumn", { bg = c.alt_bg })
  set("Conceal", { fg = c.comment })
  set("Cursor", { fg = c.bg, bg = c.fg })
  set("CursorColumn", { bg = cursorline })
  set("CursorLine", { bg = cursorline })
  set("CursorLineNr", { fg = c.fg, bg = gutter_bg, bold = true })
  set("Directory", { fg = c.type })
  set("EndOfBuffer", { fg = c.fg })
  set("ErrorMsg", { fg = c.diag_red, bold = true })
  set("FoldColumn", { fg = c.comment, bg = gutter_bg })
  set("Folded", { fg = c.comment, bg = c.alt_bg })
  set("IncSearch", { fg = c.bg, bg = c.alt })
  set("LineNr", { fg = c.comment, bg = gutter_bg })
  set("MatchParen", { fg = c.fg, bg = c.visual, bold = true })
  set("ModeMsg", { fg = c.fg, bold = true })
  set("MoreMsg", { fg = c.type })
  set("NonText", { fg = c.comment })
  set("Pmenu", { fg = c.fg, bg = c.alt_bg })
  set("PmenuSel", { fg = c.bg, bg = c.alt })
  set("PmenuSbar", { bg = c.visual })
  set("PmenuThumb", { bg = c.comment })
  set("Question", { fg = c.type })
  set("QuickFixLine", { bg = c.visual, bold = true })
  set("Search", { fg = c.bg, bg = c.number })
  set("SignColumn", { fg = c.comment, bg = gutter_bg })
  set("SpecialKey", { fg = c.comment })
  set("SpellBad", { sp = c.diag_red, undercurl = true })
  set("SpellCap", { sp = c.diag_blue, undercurl = true })
  set("SpellLocal", { sp = c.diag_yellow, undercurl = true })
  set("SpellRare", { sp = c.diag_green, undercurl = true })
  set("StatusLine", { fg = c.fg, bg = "NONE" })
  set("StatusLineNC", { fg = c.comment, bg = "NONE" })
  set("Substitute", { fg = c.bg, bg = c.diag_yellow })
  set("TabLine", { fg = c.comment, bg = "NONE" })
  set("TabLineFill", { fg = c.comment, bg = "NONE" })
  set("TabLineSel", { fg = c.fg, bg = "NONE", bold = true })
  set("Title", { fg = c.keyword, bold = true })
  set("VertSplit", { fg = c.alt_bg })
  set("Visual", { bg = c.visual })
  set("WarningMsg", { fg = c.diag_yellow, bold = true })
  set("Whitespace", { fg = c.comment })
  set("WinBar", { fg = c.fg, bg = bg })
  set("WinBarNC", { fg = c.comment, bg = bg })
  set("WinSeparator", { fg = c.alt_bg })
  set("WildMenu", { fg = c.bg, bg = c.alt })

  set("Boolean", { fg = c.number })
  set("Character", { fg = c.string })
  set("Comment", { fg = c.comment, italic = options.italic_comments })
  set("Conditional", { fg = c.keyword })
  set("Constant", { fg = c.constant })
  set("Define", { fg = c.keyword })
  set("Delimiter", { fg = c.operator })
  set("Error", { fg = c.diag_red })
  set("Exception", { fg = c.keyword })
  set("Float", { fg = c.number })
  set("Function", { fg = c.func })
  set("Identifier", { fg = c.property })
  set("Include", { fg = c.keyword })
  set("Keyword", { fg = c.keyword })
  set("Label", { fg = c.keyword })
  set("Macro", { fg = c.keyword })
  set("Number", { fg = c.number })
  set("Operator", { fg = c.operator })
  set("PreCondit", { fg = c.keyword })
  set("PreProc", { fg = c.keyword })
  set("Repeat", { fg = c.keyword })
  set("Special", { fg = c.alt })
  set("SpecialChar", { fg = c.alt })
  set("Statement", { fg = c.keyword })
  set("StorageClass", { fg = c.type })
  set("String", { fg = c.string })
  set("Structure", { fg = c.type })
  set("Tag", { fg = c.alt })
  set("Todo", { fg = c.bg, bg = c.keyword, bold = true })
  set("Type", { fg = c.type })
  set("Typedef", { fg = c.type })
  set("Underlined", { fg = c.alt, underline = true })

  set("DiagnosticError", { fg = c.diag_red })
  set("DiagnosticWarn", { fg = c.diag_yellow })
  set("DiagnosticInfo", { fg = c.diag_blue })
  set("DiagnosticHint", { fg = c.diag_green })
  set("DiagnosticOk", { fg = c.diag_green })
  set("DiagnosticUnderlineError", { sp = c.diag_red, undercurl = true })
  set("DiagnosticUnderlineWarn", { sp = c.diag_yellow, undercurl = true })
  set("DiagnosticUnderlineInfo", { sp = c.diag_blue, undercurl = true })
  set("DiagnosticUnderlineHint", { sp = c.diag_green, undercurl = true })
  set("DiagnosticVirtualTextError", { fg = c.diag_red, bg = c.alt_bg })
  set("DiagnosticVirtualTextWarn", { fg = c.diag_yellow, bg = c.alt_bg })
  set("DiagnosticVirtualTextInfo", { fg = c.diag_blue, bg = c.alt_bg })
  set("DiagnosticVirtualTextHint", { fg = c.diag_green, bg = c.alt_bg })

  set("DiffAdd", { fg = c.diag_green, bg = c.alt_bg })
  set("DiffChange", { fg = c.diag_blue, bg = c.alt_bg })
  set("DiffDelete", { fg = c.diag_red, bg = c.alt_bg })
  set("DiffText", { fg = c.diag_yellow, bg = c.visual })
  set("Added", { fg = c.diag_green })
  set("Changed", { fg = c.diag_blue })
  set("Removed", { fg = c.diag_red })

  link("@boolean", "Boolean")
  link("@character", "Character")
  link("@comment", "Comment")
  link("@conditional", "Conditional")
  link("@constant", "Constant")
  link("@constant.builtin", "Constant")
  link("@constant.macro", "Macro")
  link("@constructor", "Function")
  link("@field", "Identifier")
  link("@function", "Function")
  link("@function.builtin", "Function")
  link("@function.call", "Function")
  link("@function.macro", "Macro")
  link("@include", "Include")
  link("@keyword", "Keyword")
  link("@keyword.function", "Keyword")
  link("@keyword.operator", "Operator")
  link("@keyword.return", "Keyword")
  link("@label", "Label")
  link("@method", "Function")
  link("@method.call", "Function")
  link("@namespace", "Identifier")
  link("@number", "Number")
  link("@operator", "Operator")
  link("@parameter", "Identifier")
  link("@property", "Identifier")
  link("@punctuation.bracket", "Delimiter")
  link("@punctuation.delimiter", "Delimiter")
  link("@punctuation.special", "Special")
  link("@repeat", "Repeat")
  link("@string", "String")
  link("@string.escape", "SpecialChar")
  link("@string.regex", "String")
  link("@symbol", "Identifier")
  link("@tag", "Tag")
  link("@tag.attribute", "Identifier")
  link("@tag.delimiter", "Delimiter")
  link("@type", "Type")
  link("@type.builtin", "Type")
  link("@variable", "Identifier")
  link("@variable.builtin", "Identifier")

  link("@lsp.type.boolean", "Boolean")
  link("@lsp.type.comment", "Comment")
  link("@lsp.type.decorator", "Function")
  link("@lsp.type.enum", "Type")
  link("@lsp.type.enumMember", "Constant")
  link("@lsp.type.function", "Function")
  link("@lsp.type.interface", "Type")
  link("@lsp.type.keyword", "Keyword")
  link("@lsp.type.macro", "Macro")
  link("@lsp.type.method", "Function")
  link("@lsp.type.namespace", "Identifier")
  link("@lsp.type.number", "Number")
  link("@lsp.type.operator", "Operator")
  link("@lsp.type.parameter", "Identifier")
  link("@lsp.type.property", "Identifier")
  link("@lsp.type.string", "String")
  link("@lsp.type.struct", "Type")
  link("@lsp.type.type", "Type")
  link("@lsp.type.variable", "Identifier")

  set("GitSignsAdd", { fg = c.diag_green, bg = gutter_bg })
  set("GitSignsChange", { fg = c.diag_blue, bg = gutter_bg })
  set("GitSignsDelete", { fg = c.diag_red, bg = gutter_bg })
  set("MiniStatuslineModeNormal", { fg = c.bg, bg = c.alt, bold = true })
  set("MiniStatuslineModeInsert", { fg = c.bg, bg = c.type, bold = true })
  set("MiniStatuslineModeVisual", { fg = c.bg, bg = c.keyword, bold = true })
  set("MiniStatuslineModeReplace", { fg = c.bg, bg = c.diag_red, bold = true })
  set("MiniStatuslineModeCommand", { fg = c.bg, bg = c.number, bold = true })
  set("TelescopeBorder", { fg = c.comment, bg = "NONE" })
  set("TelescopeNormal", { fg = c.fg, bg = "NONE" })
  set("TelescopeMatching", { fg = c.alt, bold = true })
  set("TelescopeSelection", { fg = c.fg, bg = c.visual })
  set("TelescopeTitle", { fg = c.alt, bg = "NONE", bold = true })
  set("TelescopePromptNormal", { fg = c.fg, bg = "NONE" })
  set("TelescopePromptBorder", { fg = c.alt_bg, bg = "NONE" })
  set("TelescopePromptTitle", { fg = c.alt, bg = "NONE", bold = true })
  set("TelescopePromptPrefix", { fg = c.alt, bg = "NONE" })
  set("TelescopeResultsNormal", { fg = c.fg, bg = "NONE" })
  set("TelescopeResultsBorder", { fg = c.bg, bg = "NONE" })
  set("TelescopeResultsTitle", { fg = c.alt, bg = "NONE", bold = true })
  set("TelescopePreviewNormal", { fg = c.fg, bg = "NONE" })
  set("TelescopePreviewBorder", { fg = "NONE", bg = "NONE" })
  set("TelescopePreviewTitle", { fg = c.alt, bg = "NONE", bold = true })
  set("WhichKey", { fg = c.keyword })
  set("WhichKeyDesc", { fg = c.fg })
  set("WhichKeyGroup", { fg = c.type })
  set("WhichKeySeparator", { fg = c.comment })

  for group, spec in pairs(options.overrides or {}) do
    set(group, spec)
  end
end

function M.setup(user_options)
  merge(user_options)
end

function M.load(user_options)
  local from_globals = global_options()
  if next(from_globals) ~= nil or user_options then
    merge(vim.tbl_deep_extend("force", options, from_globals, user_options or {}))
  end

  if vim.g.colors_name then
    vim.cmd("highlight clear")
  end

  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "nononsense"

  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  local c = colors()
  apply_highlights(c)

  if options.terminal_colors then
    apply_terminal(c)
  end
end

setmetatable(M, {
  __call = function(_, user_options)
    M.load(user_options)
  end,
})

if ... ~= "nononsense" and vim.g.colors_name ~= "nononsense" then
  M.load()
end

return M
