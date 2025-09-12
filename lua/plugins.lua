-- plugins.lua
-- Inicialização segura dos módulos com tratamento de erro
local function safe_require(module)
  local status_ok, loaded_mod = pcall(require, module)
  if not status_ok then
    vim.notify("Erro ao carregar módulo: " .. module, vim.log.levels.ERROR)
    return false
  end
  return true
end

-- Carregar módulos em ordem específica para evitar conflitos
safe_require('home/home')
safe_require('keymap/keymap')
safe_require('lsp/lsp_keymap')
safe_require('lsp/diagnostic')
safe_require('lsp/diagnostic_advanced')

-- Carregar neo-tree por último para garantir que todas as dependências estão disponíveis
safe_require('tree/nvim_tree')

-- Configuração Treesitter
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  ensure_installed = { 
    "java", 
    "typescript", 
    "javascript", 
    "css", 
    "html", 
    "vue" 
  },
  auto_install = true,
  sync_install = false,
  indent = {
    enable = true
  },
}
