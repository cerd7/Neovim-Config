local on_attach = function(_, bufnr)
  local map = vim.keymap.set
  local opts = { noremap=true, silent=true, buffer=bufnr }

  map('n', 'gd', vim.lsp.buf.definition, opts)
  map('n', 'gdd', vim.lsp.buf.declaration, opts)
  map('n', 'gr', vim.lsp.buf.references, opts)
  map('n', 'gi', vim.lsp.buf.implementation, opts)
  map('n', 'gk', vim.lsp.buf.hover, opts)
  map('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  map('n', '<C-n>', vim.diagnostic.goto_prev, opts)
  map('n', '<C-p>', vim.diagnostic.goto_next, opts)
  map('n', 'mm', vim.lsp.buf.rename, opts)
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.java", "*.js", "*.jsx", "*.go", "*.tsx", "*.py" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
