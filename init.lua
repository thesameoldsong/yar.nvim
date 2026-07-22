require 'core'

local lazy_config = require 'core.lazy-config'

require('lazy').setup({
  { import = 'plugins' },
}, lazy_config)

-- Цветовая схема — из ~/.config/theming/schemes/current/nvim.lua (theme scheme set <имя>);
-- живое переключение (:ThemingReload) и фолбэк — в core.theming
require('core.theming').apply()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
