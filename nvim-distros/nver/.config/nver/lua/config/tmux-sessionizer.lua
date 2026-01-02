-- Neovim: run sessionizer either as fzf list (default) or for "this dir"

local function in_tmux()
  return os.getenv("TMUX") ~= nil
end

-- mode: "list" (no args → fzf) or "here" (pass a path)
local function sessionize(mode, path)
  local args = { "tmux", "neww", "-n", "sessionizer", "tmux-sessionizer" }
  local fallback_cmd = "tabnew | terminal tmux-sessionizer"

  if mode == "here" then
    path = path or vim.loop.cwd()
    table.insert(args, path)
    fallback_cmd = fallback_cmd .. " " .. vim.fn.shellescape(path)
  end

  if in_tmux() then
    vim.system(args, { detach = true })
  else
    vim.cmd(fallback_cmd)
  end
end

-- Commands
vim.api.nvim_create_user_command("Sessionize", function()
  -- NO ARG → your script shows the fzf list
  sessionize("list")
end, {})

vim.api.nvim_create_user_command("SessionizeHere", function()
  -- Pass current file's dir → no list
  sessionize("here", vim.fn.expand("%:p:h"))
end, {})

-- Keymaps
vim.keymap.set("n", "<leader>ts", function() sessionize("list") end,
  { desc = "Sessionize (fzf pick from list)" })
vim.keymap.set("n", "<leader>tp", function() sessionize("here", vim.fn.expand("%:p:h")) end,
  { desc = "Sessionize current file's directory" })
