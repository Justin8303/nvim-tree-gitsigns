local M = {}

function M.setup()
  local function sync_nvimtree_gitsigns_colors()
    local git_map = {
      Staged    = "GitSignsAdd",
      Untracked = "GitSignsUntracked",
      Deleted   = "GitSignsDelete",
      Dirty     = "GitSignsChange",
      Renamed   = "GitSignsChange",
      Unmerged  = "GitSignsChangeDelete",
      Ignored   = "Comment",
    }
    for tree, gs in pairs(git_map) do
      local group = "NvimTreeGit" .. tree .. "Icon"
      local ok, t = pcall(vim.api.nvim_get_hl, 0, { name = gs })
      if ok and t.fg then
        vim.api.nvim_set_hl(0, group, { fg = string.format("#%06x", t.fg) })
      end
    end
    local ok, api = pcall(require, "nvim-tree.api")
    if ok then api.tree.reload() end
  end

  sync_nvimtree_gitsigns_colors()

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("NvimTreeGitColors", { clear = true }),
    pattern = "*",
    callback = function()
      vim.defer_fn(sync_nvimtree_gitsigns_colors, 100)
    end,
  })
end

return M
