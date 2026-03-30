-- Russian JCUKEN -> English QWERTY transliteration.
-- Remove this file and its require in core/init.lua to disable Russian layout support.
-- Also remove lua/plugins/langmapper.lua if you don't need it.

-- langmap: translates input characters at the core level for Normal/Visual/Select/Operator-pending.
vim.opt.langmap = table.concat({
  'йq', 'цw', 'уe', 'кr', 'еt', 'нy', 'гu', 'шi', 'щo', 'зp',
  'х[', 'ъ]', 'фa', 'ыs', 'вd', 'аf', 'пg', 'рh', 'оj', 'лk',
  'дl', 'ж\\;', "э'", 'яz', 'чx', 'сc', 'мv', 'иb', 'тn', 'ьm',
  'б\\,', 'ю.', 'ё`',
  'ЙQ', 'ЦW', 'УE', 'КR', 'ЕT', 'НY', 'ГU', 'ШI', 'ЩO', 'ЗP',
  'Х{', 'Ъ}', 'ФA', 'ЫS', 'ВD', 'АF', 'ПG', 'РH', 'ОJ', 'ЛK',
  'ДL', 'Ж:', 'Э\\"', 'ЯZ', 'ЧX', 'СC', 'МV', 'ИB', 'ТN', 'ЬM',
  'Б<', 'Ю>', 'Ё~',
}, ',')

-- Command-line mode: translate Russian -> English only for : commands.
-- Search (/ and ?) keeps Russian characters for searching Russian text.
local ru_en_pairs = {
  { 'й', 'q' }, { 'ц', 'w' }, { 'у', 'e' }, { 'к', 'r' }, { 'е', 't' },
  { 'н', 'y' }, { 'г', 'u' }, { 'ш', 'i' }, { 'щ', 'o' }, { 'з', 'p' },
  { 'х', '[' }, { 'ъ', ']' }, { 'ф', 'a' }, { 'ы', 's' }, { 'в', 'd' },
  { 'а', 'f' }, { 'п', 'g' }, { 'р', 'h' }, { 'о', 'j' }, { 'л', 'k' },
  { 'д', 'l' }, { 'ж', ';' }, { 'э', "'" }, { 'я', 'z' }, { 'ч', 'x' },
  { 'с', 'c' }, { 'м', 'v' }, { 'и', 'b' }, { 'т', 'n' }, { 'ь', 'm' },
  { 'б', ',' }, { 'ю', '.' }, { 'ё', '`' },
  { 'Й', 'Q' }, { 'Ц', 'W' }, { 'У', 'E' }, { 'К', 'R' }, { 'Е', 'T' },
  { 'Н', 'Y' }, { 'Г', 'U' }, { 'Ш', 'I' }, { 'Щ', 'O' }, { 'З', 'P' },
  { 'Х', '{' }, { 'Ъ', '}' }, { 'Ф', 'A' }, { 'Ы', 'S' }, { 'В', 'D' },
  { 'А', 'F' }, { 'П', 'G' }, { 'Р', 'H' }, { 'О', 'J' }, { 'Л', 'K' },
  { 'Д', 'L' }, { 'Ж', ':' }, { 'Э', '"' }, { 'Я', 'Z' }, { 'Ч', 'X' },
  { 'С', 'C' }, { 'М', 'V' }, { 'И', 'B' }, { 'Т', 'N' }, { 'Ь', 'M' },
  { 'Б', '<' }, { 'Ю', '>' }, { 'Ё', '~' },
}

for _, pair in ipairs(ru_en_pairs) do
  vim.keymap.set('c', pair[1], function()
    if vim.fn.getcmdtype() == ':' then
      return pair[2]
    end
    return pair[1]
  end, { noremap = true, expr = true })
end

-- Bidirectional lookup tables built from ru_en_pairs.
local ru_to_en = {}
local en_to_ru = {}
for _, pair in ipairs(ru_en_pairs) do
  ru_to_en[pair[1]] = pair[2]
  en_to_ru[pair[2]] = pair[1]
end

-- Track the region of text entered during the last Insert session.
local last_insert_region = {}

vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    last_insert_region.start_row = pos[1] - 1
    last_insert_region.start_col = pos[2]
    last_insert_region.end_row = nil
    last_insert_region.end_col = nil
  end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    local row = pos[1] - 1
    local col = pos[2]
    local line = vim.api.nvim_get_current_line()
    -- Compute exclusive end (advance past the multi-byte char at cursor)
    local end_col = col
    if col < #line then
      end_col = col + 1
      while end_col < #line and line:byte(end_col + 1) >= 0x80 and line:byte(end_col + 1) <= 0xBF do
        end_col = end_col + 1
      end
    end
    last_insert_region.end_row = row
    last_insert_region.end_col = end_col
  end,
})

-- Swap layout of last inserted text (RU↔EN).
-- Detects direction automatically: if text has Cyrillic → RU→EN, otherwise EN→RU.
local function swap_last_insert_layout()
  local r = last_insert_region
  if not r.end_row then
    return
  end

  local lines = vim.api.nvim_buf_get_text(0, r.start_row, r.start_col, r.end_row, r.end_col, {})
  if #lines == 0 or (#lines == 1 and lines[1] == '') then
    return
  end

  local text = table.concat(lines, '\n')
  local has_cyrillic = text:find '[\208-\209][\128-\191]' ~= nil
  local map = has_cyrillic and ru_to_en or en_to_ru

  local result = {}
  for _, line in ipairs(lines) do
    local converted = ''
    for char in line:gmatch '[%z\1-\127\194-\244][\128-\191]*' do
      converted = converted .. (map[char] or char)
    end
    table.insert(result, converted)
  end

  vim.api.nvim_buf_set_text(0, r.start_row, r.start_col, r.end_row, r.end_col, result)

  -- Update region so pressing again toggles back
  r.end_row = r.start_row + #result - 1
  if #result == 1 then
    r.end_col = r.start_col + #result[1]
  else
    r.end_col = #result[#result]
  end
end

vim.keymap.set('n', '<leader>r', swap_last_insert_layout, { desc = 'Swap layout of last insert' })
