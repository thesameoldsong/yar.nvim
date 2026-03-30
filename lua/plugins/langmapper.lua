-- langmap (core/options.lua) handles single-key translations in Normal/Visual/Operator-pending,
-- but does NOT apply to subsequent characters in a pending mapping sequence (e.g. after <leader>).
-- langmapper fills that gap by creating duplicate plugin keymaps with Russian equivalents,
-- so <leader> combos like <leader>sf work when typed as <leader>ыа on Russian layout.
return {
  'Wansmer/langmapper.nvim',
  lazy = false,
  priority = 10000,
  config = function()
    local langmapper = require 'langmapper'

    langmapper.setup {
      hack_keymap = true,
      disable_hack_modes = { 'i' },
      default_layout = [[ABCDEFGHIJKLMNOPQRSTUVWXYZ<>?:"{}~abcdefghijklmnopqrstuvwxyz,./;'[]`]],
      layouts = {
        ru = {
          id = 'ru',
          default_layout = nil,
          layout = [[ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯБЮ,ЖЭХЪËфисвуапршолдьтщзйкыегмцчнябю.жэхъё]],
        },
      },
    }

    langmapper.automapping { buffer = false }
  end,
}
