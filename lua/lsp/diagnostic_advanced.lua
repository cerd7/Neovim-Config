-- Script de diagnóstico LSP para Neovim
-- filepath: /home/cerddev/.config/nvim/lua/lsp/diagnostic.lua

local M = {}

-- Configuração de diagnósticos
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    severity = vim.diagnostic.severity.ERROR,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

-- Mostrar diagnósticos automaticamente
vim.cmd [[
  autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, { focusable = false })
]]

-- Função para verificar status do LSP
function M.check_lsp_status()
  local clients = vim.lsp.get_active_clients()
  
  if #clients == 0 then
    vim.notify("❌ Nenhum cliente LSP ativo neste buffer", vim.log.levels.WARN)
    vim.notify("💡 Tente executar :LspStart tsserver", vim.log.levels.INFO)
    return false
  end
  
  vim.notify("✅ LSP Ativo - Clientes conectados:", vim.log.levels.INFO)
  for _, client in ipairs(clients) do
    local status = client.server_capabilities
    local capabilities = {}
    
    if status.hoverProvider then table.insert(capabilities, "hover") end
    if status.definitionProvider then table.insert(capabilities, "definition") end
    if status.completionProvider then table.insert(capabilities, "completion") end
    if status.documentFormattingProvider then table.insert(capabilities, "formatting") end
    if status.renameProvider then table.insert(capabilities, "rename") end
    
    vim.notify(string.format("🔧 %s (ID: %d) - %s", 
      client.name, 
      client.id, 
      table.concat(capabilities, ", ")), 
      vim.log.levels.INFO)
  end
  
  return true
end

-- Função para testar funcionalidades LSP
function M.test_lsp_features()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  
  if #clients == 0 then
    vim.notify("❌ Nenhum LSP ativo neste buffer", vim.log.levels.ERROR)
    return
  end
  
  vim.notify("🧪 Testando funcionalidades LSP...", vim.log.levels.INFO)
  
  -- Test hover
  vim.lsp.buf.hover()
  
  -- Test completion (se disponível)
  local line = vim.api.nvim_get_current_line()
  if line:match("[%w_]+$") then
    vim.notify("💡 Completion disponível - pressione <C-x><C-o>", vim.log.levels.INFO)
  end
  
  -- Mostrar informações do buffer
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand('%:t')
  vim.notify(string.format("📄 Buffer: %s (%s)", filename, filetype), vim.log.levels.INFO)
end

-- Função para reiniciar LSP
function M.restart_lsp()
  local clients = vim.lsp.get_active_clients()
  
  if #clients == 0 then
    vim.notify("❌ Nenhum LSP para reiniciar", vim.log.levels.WARN)
    return
  end
  
  vim.notify("🔄 Reiniciando LSP...", vim.log.levels.INFO)
  
  for _, client in ipairs(clients) do
    vim.lsp.stop_client(client.id)
  end
  
  -- Recarregar configuração
  vim.defer_fn(function()
    require("lsp.dev_lsp")
    vim.notify("✅ LSP reiniciado com sucesso", vim.log.levels.INFO)
  end, 1000)
end

-- Função para mostrar logs LSP
function M.show_lsp_logs()
  vim.cmd('LspLog')
end

-- Comandos Vim para diagnóstico
vim.api.nvim_create_user_command("LspDiag", function()
  M.check_lsp_status()
end, {})

vim.api.nvim_create_user_command("LspTest", function()
  M.test_lsp_features()
end, {})

vim.api.nvim_create_user_command("LspRestart", function()
  M.restart_lsp()
end, {})

vim.api.nvim_create_user_command("LspLogs", function()
  M.show_lsp_logs()
end, {})

return M
