-- Arquivo de inicialização LSP simples
-- Este arquivo apenas chama o dev_lsp.lua para compatibilidade

local M = {}

function M.setup()
  -- Apenas chama o dev_lsp.lua
  require("lsp.dev_lsp")
end

-- Chamar setup automaticamente quando este arquivo for carregado
M.setup()

return M
