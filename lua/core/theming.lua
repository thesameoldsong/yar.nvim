-- Цветовая схема — из ~/.config/theming/schemes/current/nvim.lua (theme scheme set <имя>).
-- Один источник и для старта (init.lua), и для живого переключения: `theme scheme
-- set` дёргает `:ThemingReload` по nvim-сокету, как пингует kitty/qs/hypr.
--
-- Схема отдаёт одно из двух:
--   { colorscheme = "имя" }              — готовый сторонний плагин (tokyonight, gruvbox…)
--   { palette = {base00..base0F}, name } — палитра схемы, если плагина нет (cybr, dracula,
--                                          monochrome); красим через mini.base16 прямо из палитры
local M = {}

local FALLBACK = 'tokyonight-night'
local state = vim.env.XDG_STATE_HOME
if not state or state:sub(1, 1) ~= "/" then state = vim.env.HOME .. "/.local/state" end
local SCHEME = vim.fs.joinpath(state, "theming/current/nvim.lua")

-- спецификация активной схемы (или nil, если файла/таблицы нет)
local function load_spec()
  local ok, spec = pcall(dofile, SCHEME)
  if not ok and vim.uv.fs_stat(SCHEME) then error(spec) end
  if ok and type(spec) ~= 'table' then error('invalid theming specification') end
  return ok and spec or nil
end

-- покрасить из палитры схемы (base16 через mini.base16); true при успехе
local function apply_palette(spec)
  return pcall(function()
    require('mini.base16').setup { palette = spec.palette }
    vim.g.colors_name = spec.name or 'theming' -- mini.base16 сбрасывает colors_name в nil
  end)
end

-- применить активную схему; при любой неудаче — фолбэк
function M.apply()
  local spec = load_spec()
  if spec then
    if type(spec.colorscheme) == 'string' then
      -- часть плагинов выбирает вариант (dark/light) через setup{style=...},
      -- а не отдельным colorscheme (onedark.nvim) — прогреваем перед :colorscheme
      if type(spec.style) == 'string' then
        pcall(function()
          require(spec.colorscheme).setup { style = spec.style }
        end)
      end
      local ok, err = pcall(vim.cmd.colorscheme, spec.colorscheme)
      if not ok then error(err) end
      return
    elseif type(spec.palette) == 'table' and apply_palette(spec) then
      return
    end
  end
  vim.cmd.colorscheme(FALLBACK)
end

-- ручной перезачит + точка входа для `theme` (см. apply() в theming/bin/theme)
vim.api.nvim_create_user_command('ThemingReload', M.apply, { desc = 'Перечитать colorscheme из схемы theming' })

return M
