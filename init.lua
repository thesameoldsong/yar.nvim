require 'core'

local lazy_config = require 'core.lazy-config'

require('lazy').setup({
  { import = 'plugins' },
}, lazy_config)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
