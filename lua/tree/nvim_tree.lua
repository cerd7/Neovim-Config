-- Configurar neo-tree com tratamento de erro para notificações
local status_ok, neo_tree = pcall(require, "neo-tree")
if not status_ok then
  vim.notify("neo-tree não encontrado!", vim.log.levels.WARN)
  return
end

-- Configurar tratamento seguro para notificações
local ok, _ = pcall(function()
  -- Garantir que o log do neo-tree use o notify de forma segura
  require("neo-tree.log").notify = function(msg, level)
    local ok_notify, _ = pcall(function()
      vim.notify(msg, level)
    end)
    if not ok_notify then
      print(msg)
    end
  end
end)

neo_tree.setup({
  close_if_last_window = true,
  enable_git_status = true,
  enable_diagnostics = true,
  sort_case_insensitive = true,
  log_level = "warn", -- Diminuir nível de log para reduzir notificações
  log_to_file = false, -- Desativar log em arquivo
  window = {
    width = 30,
    mappings = {
      ["<space>"] = "toggle_node",
      ["<cr>"] = "open",
      ["P"] = { "toggle_preview", config = { use_float = true } },
    },
  },
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = true,
    },
    follow_current_file = {
      enabled = true,
    },
    use_libuv_file_watcher = true,
  },
})

