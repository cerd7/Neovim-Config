local M = {}

function M.setup()
  -- Verificar se o jdtls está disponível
  local status_ok, jdtls = pcall(require, "jdtls")
  if not status_ok then
    vim.notify("jdtls não encontrado. Verifique se o plugin está instalado", vim.log.levels.ERROR)
    return
  end

  -- Obter caminho do home e do workspace
  local home = os.getenv("HOME")
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local workspace_dir = home .. "/.local/share/eclipse/" .. project_name

  -- Tentar carregar o lsp_keymap
  local on_attach
  local status_keymap_ok, lsp_keymap = pcall(require, "lsp.lsp_keymap")
  if status_keymap_ok then
    on_attach = lsp_keymap.on_attach
  else
    -- Fallback para uma função básica de on_attach caso o módulo não seja encontrado
    on_attach = function(client, bufnr)
      vim.notify("Usando função on_attach básica para Java LSP", vim.log.levels.WARN)
      -- Keybindings básicos
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      local opts = { noremap=true, silent=true }
      buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
      buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
      buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
      buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
      buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
      buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    end
  end

  -- Verificar possíveis caminhos do jdt.ls
  local possible_jdtls_paths = {
    home .. "/.local/share/nvim/lsp_servers/jdtls",
    home .. "/.local/share/nvim/mason/packages/jdtls",
    home .. "/.config/nvim/jdtls",
    "/usr/local/share/eclipse.jdt.ls",
    "/opt/eclipse.jdt.ls"
  }
  
  local jdtls_path = nil
  for _, path in ipairs(possible_jdtls_paths) do
    if vim.fn.isdirectory(path) == 1 then
      jdtls_path = path
      break
    end
  end
  
  if not jdtls_path then
    vim.notify("Nenhum diretório JDTLS encontrado. Execute o script de instalação: ~/.config/nvim/scripts/install_jdtls.sh", vim.log.levels.ERROR)
    return
  end
  
  vim.notify("Usando JDTLS em: " .. jdtls_path, vim.log.levels.INFO)
  
  -- Tentar encontrar o jar do equinox launcher
  local function find_equinox_launcher(plugins_dir)
    if vim.fn.isdirectory(plugins_dir) ~= 1 then
      return nil
    end
    
    local launcher_pattern = "org.eclipse.equinox.launcher_.*%.jar"
    local command = "find " .. plugins_dir .. " -name '" .. launcher_pattern .. "' | sort | tail -n 1"
    local handle = io.popen(command)
    
    if handle then
      local result = handle:read("*a"):gsub("%s+$", "")
      handle:close()
      return result ~= "" and result or nil
    end
    return nil
  end

  -- Procurar o launcher em diversos locais
  local equinox_launcher = find_equinox_launcher(jdtls_path .. "/plugins")
  
  if not equinox_launcher then
    -- Tentar encontrar diretamente no diretório raiz do jdtls (pode acontecer com algumas instalações)
    equinox_launcher = find_equinox_launcher(jdtls_path)
  end
  
  if not equinox_launcher then
    -- Usar find para procurar em toda a árvore do jdtls
    local command = "find " .. jdtls_path .. " -name 'org.eclipse.equinox.launcher_*.jar' | sort | tail -n 1"
    local handle = io.popen(command)
    if handle then
      equinox_launcher = handle:read("*a"):gsub("%s+$", "")
      handle:close()
    end
  end
  
  if not equinox_launcher or equinox_launcher == "" then
    vim.notify("Eclipse launcher jar não encontrado. O LSP Java não vai funcionar.", vim.log.levels.ERROR)
    vim.notify("Instale o jdtls usando: :LspInstall jdtls ou :MasonInstall jdtls", vim.log.levels.INFO)
    return
  end
  
  vim.notify("Iniciando Java LSP com: " .. equinox_launcher, vim.log.levels.INFO)

  -- Determinar o diretório de configuração correto
  local config_dir = jdtls_path .. '/config_linux'
  if vim.fn.isdirectory(config_dir) ~= 1 then
    -- Tentar outros possíveis diretórios de configuração
    local possible_config_dirs = {
      jdtls_path .. '/config_linux',
      jdtls_path .. '/config',
    }
    
    for _, dir in ipairs(possible_config_dirs) do
      if vim.fn.isdirectory(dir) == 1 then
        config_dir = dir
        break
      end
    end
    
    -- Se não encontrar, procurar recursivamente
    if vim.fn.isdirectory(config_dir) ~= 1 then
      local handle = io.popen("find " .. jdtls_path .. " -name 'config_linux' -type d | head -n 1")
      if handle then
        local result = handle:read("*a"):gsub("%s+$", "")
        handle:close()
        if result ~= "" then
          config_dir = result
        end
      end
    end
  end
  
  -- Verificar se o equinox_launcher foi encontrado
  if not equinox_launcher or equinox_launcher == "" then
    vim.notify("Launcher do Eclipse não encontrado. O LSP não vai funcionar.", vim.log.levels.ERROR)
    return
  end
  
  vim.notify("Usando configuração em: " .. config_dir, vim.log.levels.INFO)
  vim.notify("Usando launcher: " .. equinox_launcher, vim.log.levels.INFO)
  
  -- Configurações do JDTLS
  local config = {
    cmd = {
      'java',
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-Xms1g',
      '-Xmx2g',
      '--add-modules=ALL-SYSTEM',
      '--add-opens', 'java.base/java.util=ALL-UNNAMED',
      '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
      '-jar', equinox_launcher,
      '-configuration', config_dir,
      '-data', workspace_dir
    },
    root_dir = jdtls.setup.find_root({'.git', 'mvnw', 'gradlew', 'build.gradle', 'pom.xml', 'build.xml'}),
    settings = {
      java = {
        format = {
          enabled = true,
          settings = {
            url = jdtls_path .. "/formatter.xml"
          }
        },
        signatureHelp = { enabled = true },
        contentProvider = { preferred = 'fernflower' },
        completion = {
          favoriteStaticMembers = {
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.junit.Assert.*",
            "org.junit.Assume.*",
            "org.junit.jupiter.api.Assertions.*",
            "org.junit.jupiter.api.Assumptions.*",
            "org.junit.jupiter.api.DynamicContainer.*",
            "org.junit.jupiter.api.DynamicTest.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse"
          },
          filteredTypes = {
            "com.sun.*",
            "io.micrometer.shaded.*",
            "java.awt.*",
            "jdk.*",
            "sun.*",
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        }
      }
    },
    init_options = {
      bundles = {}
    },
    filetypes = { "java" },
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  }

  -- Iniciar o JDTLS
  jdtls.start_or_attach(config)
  vim.notify("Java LSP inicializado com sucesso", vim.log.levels.INFO)
end

return M

