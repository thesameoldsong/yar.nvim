-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

local function smart_markdown_follow()
  local line = vim.api.nvim_get_current_line()

  local start_pos = line:find('%(', 1)
  local end_pos = line:find('%)', start_pos)

  if start_pos and end_pos then
    local path = line:sub(start_pos + 1, end_pos - 1)

    path = path:gsub('%%20', ' ')

    vim.cmd('edit ' .. vim.fn.fnameescape(path))
  else
    vim.api.nvim_feedkeys('gf', 'n', false)
  end
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.keymap.set('n', 'gf', smart_markdown_follow, { buffer = true, desc = 'Follow link with space decoding' })
  end,
})
