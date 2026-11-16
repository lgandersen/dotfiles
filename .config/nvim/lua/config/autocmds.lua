-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Hermes /prompt compose buffers carry `#!` header lines that Hermes strips on
-- read-back. LazyVim's markdown extra formats on save with markdownlint-cli2,
-- whose MD018 fix rewrites `#!` to `# !` — which no longer matches the strip
-- and leaks the header into the prompt. Skip autoformat for these buffers.
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = { "*/hermes_prompt_*.md" },
  callback = function(args)
    vim.b[args.buf].autoformat = false
  end,
})
