-- bufferline.nvim tweaks.
--
-- LazyVim maps <S-h>/<S-l> (H/L) to BufferLineCyclePrev/Next. Disable those so
-- the builtin H/L (top/bottom of window) survive — restored in
-- lua/config/keymaps.lua. Buffer cycling stays on [b / ]b.
return {
  "akinsho/bufferline.nvim",
  keys = {
    { "<S-h>", false },
    { "<S-l>", false },
  },
}
