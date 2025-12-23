return {
  'Wansmer/langmapper.nvim',
  lazy = false,
  priority = 10000, -- High priority is essential for correct mapping
  config = function()
    local langmapper = require 'langmapper'

    langmapper.setup {
      -- 1. Automate the mapping of other plugins
      -- This wraps vim.keymap.set to automatically create the translated version
      hack_keymap = true,
      disable_hack_modes = { 'i' }, -- Exclude insert mode (we want native typing there)

      -- 2. Define the 'Standard' English layout
      -- This is the QWERTY reference for translation
      default_layout = [[ABCDEFGHIJKLMNOPQRSTUVWXYZ<>?:"{}~abcdefghijklmnopqrstuvwxyz,./;'[]`]],

      -- 3. Define your non-English layouts
      -- The characters must match the positions in default_layout exactly.
      layouts = {
        -- Example: Russian Layout (JCUKEN)
        ru = {
          id = 'com.apple.keylayout.Russian', -- Optional: OS specific layout ID
          default_layout = nil,
          layout = [[ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯБЮ,ЖЭХЪËфисвуапршолдьтщзйкыегмцчнябю.жэхъё]],
        },
      },

      -- 4. Context Aware Switching (Optional but recommended)
      -- This helps if you want to detect OS layout changes
      os = {
        -- Example for macOS (requires `im-select` installed via brew)
        Darwin = {
          get_current_layout_id = function()
            local cmd = 'im-select'
            if vim.fn.executable(cmd) == 1 then
              local output = vim.split(vim.fn.system(cmd), '\n')
              return output[1]
            end
          end,
        },
      },
    }

    -- 5. Initialize the automation
    -- This handles built-in mappings and prevents layout conflicts
    langmapper.automapping { buffer = false }
  end,
}
