---- external setup

-- - install git and neovim. e.g., with guix as package-manager, run:
--   guix install git neovim
-- - install "lazy" as neovim-specific package-manager:
--   git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim
-- - install code-formatter and language servers using npm:
--   npm i -g prettier typescript typescript-language-server vscode-langservers-extracted

vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
require('lazy').setup(
  {
    {
      'ellisonleao/gruvbox.nvim',
      priority = 1000,
    },

    {
      'navarasu/onedark.nvim',
      priority = 1000,
    },

    ---- autocompletion

    {
      -- package recommended by https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion/217feffc675a17d8ab95259ed9d4c6d62e1cd2e1#autocompletion-not-built-in-vs-completion-built-in
      'hrsh7th/nvim-cmp',
      config = function(cmp)
        local cmp = require('cmp')
        cmp.setup({
          completion = { completeopt = 'menu,menuone,noinsert' },
          -- if desired, choose another keymap-preset:
          mapping = cmp.mapping.preset.insert({
            ['<C-u>'] = cmp.mapping.scroll_docs(-5),
            ['<C-d>'] = cmp.mapping.scroll_docs(5),
            ['<CR>'] = cmp.mapping.confirm({ select = true })
          }),
          -- optionally, add more completion-sources:
          sources = cmp.config.sources({{ name = 'nvim_lsp' }}),
        })
      end,
    },

    ---- code formatting

		{
			'mhartington/formatter.nvim',
			config = function()
				local formatter_prettier = { require('formatter.defaults.prettier') }
				require("formatter").setup({
					filetype = {
						javascript      = formatter_prettier,
						javascriptreact = formatter_prettier,
						typescript      = formatter_prettier,
						typescriptreact = formatter_prettier,
					}
				})
				vim.api.nvim_create_augroup('BufWritePostFormatter', {})
				vim.api.nvim_create_autocmd('BufWritePost', {
					command = 'FormatWrite',
					group = 'BufWritePostFormatter',
					pattern = { '*.mjs', '*.js', '*.jsx', '*.ts', '*.tsx' },
				})
      end,
      ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    },

    ---- language server protocol (lsp)

    {
      -- use official lspconfig package (and enable completion):
      'neovim/nvim-lspconfig', dependencies = { 'hrsh7th/cmp-nvim-lsp' },
      config = function()
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
        lsp_capabilities.textDocument.completion.completionItem.snippetSupport = false
        local lsp_on_attach = function(client, bufnr)
          local bufopts = { noremap=true, silent=true, buffer=bufnr }
          -- following keymap is based on both lspconfig and lsp-zero.nvim:
          -- - https://github.com/neovim/nvim-lspconfig/blob/fd8f18fe819f1049d00de74817523f4823ba259a/README.md?plain=1#L79-L93
          -- - https://github.com/VonHeikemen/lsp-zero.nvim/blob/18a5887631187f3f7c408ce545fd12b8aeceba06/lua/lsp-zero/server.lua#L285-L298
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help                        , bufopts)
          vim.keymap.set('n', 'K'    , vim.lsp.buf.hover                                 , bufopts)
          vim.keymap.set('n', 'gD'   , vim.lsp.buf.declaration                           , bufopts)
          vim.keymap.set('n', 'gd'   , vim.lsp.buf.definition                            , bufopts)
          vim.keymap.set('n', 'gi'   , vim.lsp.buf.implementation                        , bufopts)
          vim.keymap.set('n', 'go'   , vim.lsp.buf.type_definition                       , bufopts)
          vim.keymap.set('n', 'gr'   , vim.lsp.buf.references                            , bufopts)
          vim.keymap.set('n', 'ga'   , vim.lsp.buf.code_action                           , bufopts) -- lspconfig: <space>ca; lsp-zero: <F4>
          m.keymap.set('n', 'g='   , function() vim.lsp.buf.format { async = true } end, bufopts) -- lspconfig: <space>f
          m.keymap.set('n', 'g.'   , vim.lsp.buf.rename                                , bufopts) -- lspconfig: <space>rn; lsp-zero: <F2>
        end
        local lspconfig = require('lspconfig')

        lspconfig.rust_analyzer.setup({
          capabilities = lsp_capabilities,
          on_attach = lsp_on_attach,
          settings = {
            ['rust-analyzer'] = {
              imports = {
                granularity = {
                  group = "module",
                },
                prefix = "self",
              },
              cargo = {
                buildScripts = {
                  enable = true,
                },
              },
              procMacro = {
                enable = true
              },
            },
          },
        })
        -- enable both language-servers for both eslint and typescript:
        for _, server in pairs({ 'eslint', 'tsserver' }) do
          lspconfig[server].setup({
            capabilities = lsp_capabilities,
            on_attach = lsp_on_attach,
          })
        end
      end,
      ft = { 'rust', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    },

    ---- indendation detection
    -- automatically configure indentation when a file is opened.

    { 'nmac427/guess-indent.nvim' },
    { 'hashivim/vim-terraform' },
    { "jparise/vim-graphql" },
    { "prisma/vim-prisma" },

    { 'github/copilot.vim' },

    ---- file navigation and more

    { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' },
      cmd = "Telescope",
      config = function()
        require('telescope').setup({
					pickers = {
						find_files = {
							hidden = true
						}
					},
					defaults = {
						file_ignore_patterns = {
							"node_modules", ".git/", "dist", "yarn.lock"
						},
					}
        })
			end,
    },

    ---- tree-sitter

    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      config = function()
        require('nvim-treesitter.configs').setup({
          -- for syntax-highlight, instead of regular expressions, use tree-sitter:
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
        })
      end,
    },
  },

	---- ChatGPT
	{
		"jackMort/ChatGPT.nvim",
		event = "VeryLazy",
		config = function()
			require("chatgpt").setup()
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim"
		}
	},


  ---- lazy (package manager)

  {
    ui = {
      -- instead of emoji-icons, use ascii-strings:
      icons = {
        cmd = 'CMD',
        config = 'CONFIG',
        event = 'EVENT',
        ft = 'FT',
        init = 'INIT',
        keys = 'KEYS',
        plugin = 'PLUGIN',
        runtime = 'RUNTIME',
        source = 'SOURCE',
        start = 'START',
        task = 'TASK',
        lazy = 'LAZY',
      },
    },
  }
)

---- theme (2)

vim.opt.background = 'dark'
vim.cmd('colorscheme onedark')

---- miscellaneous

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.signcolumn = 'number'
vim.opt.smartindent = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.swapfile = false

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<C-l>', builtin.live_grep, {})

vim.fn.sign_define("DiagnosticSignError", {
    texthl = "",
    linehl = "",
    numhl = "DiagnosticSignError",
})

vim.fn.sign_define("DiagnosticSignWarn", {
    texthl = "",
    linehl = "",
    numhl = "DiagnosticSignWarn",
})

vim.fn.sign_define("DiagnosticSignInfo", {
    texthl = "",
    linehl = "",
    numhl = "DiagnosticSignInfo",
})

vim.fn.sign_define("DiagnosticSignHint", {
    texthl = "",
    linehl = "",
    numhl = "DiagnosticSignHint",
})

vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

-- Set a very short timeout for terminal mode
vim.cmd [[ autocmd TermOpen * setlocal ttimeoutlen=1 ]]

-- Reset the timeout when leaving terminal mode (optional, set it to your preferred default)
vim.cmd [[ autocmd TermClose * setlocal ttimeoutlen=50 ]]

-- Enable mouse support
vim.opt.mouse = 'a'
