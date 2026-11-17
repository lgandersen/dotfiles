-- bufferline.nvim tweaks.
--
-- <S-h>/<S-l> are freed for builtin H/L (see lua/config/keymaps.lua); buffer
-- cycling moves to <C-p>/<C-n>.
return {
  "akinsho/bufferline.nvim",
  keys = {
    { "<S-h>", false },
    { "<S-l>", false },
    { "<C-p>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<C-n>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
  },
}
