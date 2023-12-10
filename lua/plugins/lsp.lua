return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v1.x',
  dependencies = {
    -- LSP Support
    { 'neovim/nvim-lspconfig' },

    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/cmp-nvim-lua' },
    { 'onsails/lspkind.nvim' },
    { 'folke/neodev.nvim' },

    -- Linting
    { 'mfussenegger/nvim-lint' },

    -- Snippets
    { 'L3MON4D3/LuaSnip' },
    { 'rafamadriz/friendly-snippets' },

    -- Esthetic
    { 'folke/trouble.nvim' },

    -- Misc
    {
      'stevearc/conform.nvim',
    },

    -- Flutter
    {
      'akinsho/flutter-tools.nvim',
      lazy = false,
      dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
      },
      config = true,
    },

    -- Rust
    { 'simrat39/rust-tools.nvim' },
    {
      'saecki/crates.nvim',
      tag = 'v0.4.0',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('crates').setup()
      end,
    },
  },
  config = function()
    local lsp = require 'lsp-zero'

    require('neodev').setup {}

    lsp.preset 'recommended'
    lsp.nvim_workspace()
    lsp.set_preferences {
      sign_icons = {
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = '»',
      },
    }

    -- Configure Servers
    lsp.setup_servers {
      'lua_ls',
      'rust_analyzer',
      'zls',
      'tsserver',
      'clangd',
      'tailwindcss',
      'dartls',
      'gopls',
      'bashls',
      'jedi_language_server',
      'html',
      'cssls',
      'csharp_ls',
    }

    require('lspconfig').nil_ls.setup {
      settings = {
        ['nil'] = {
          nix = {
            flake = {
              autoArchive = true,
              autoEvalInputs = true,
            },
          },
        },
      },
    }

    lsp.on_attach(function(client, _)
      require('lsp-format').on_attach(client)
      vim.keymap.set('n', '<space>ca', function()
        vim.lsp.buf.code_action { apply = true }
      end, bufopts)
    end)
    lsp.setup()

    local cmp = require 'cmp'
    local cmp_action = require('lsp-zero').cmp_action()

    vim.api.nvim_create_autocmd('BufRead', {
      group = vim.api.nvim_create_augroup('CmpSourceCargo', { clear = true }),
      pattern = 'Cargo.toml',
      callback = function()
        cmp.setup.buffer { sources = { { name = 'crates' } } }
      end,
    })

    local opts = { silent = true }
    vim.keymap.set('n', '<leader>cp', require('crates').show_popup, opts)

    cmp.setup {
      mapping = {
        ['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
      },
      window = {
        completion = {
          winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
          col_offset = -3,
          side_padding = 0,
        },
      },
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          local kind = require('lspkind').cmp_format { mode = 'symbol_text', maxwidth = 50 }(entry, vim_item)
          local strings = vim.split(kind.kind, '%s', { trimempty = true })
          kind.kind = ' ' .. (strings[1] or '') .. ' '
          kind.menu = '    (' .. (strings[2] or '') .. ')'

          return kind
        end,
      },
    }

    vim.opt.signcolumn = 'yes' -- Disable lsp signals shifting buffer

    vim.diagnostic.config {
      virtual_text = true,
    }

    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        nix = { 'alejandra' },
        rust = { 'rustfmt' },
        markdown = { 'mdformat' },
        typescript = { 'prettier' },
        javascript = { 'prettier' },
        typescriptreact = { 'prettier' },
        go = { 'gofumpt' },
        html = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_md = 500,
      },
    }

    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*',
      callback = function(args)
        require('conform').format { bufnr = args.buf }
      end,
    })

    -- lint
    require('lint').linters_by_ft = {
      nix = { 'statix' },
    }
    vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
      callback = function()
        require('lint').try_lint()
      end,
    })

    local lsnip = require 'luasnip'
    local s = lsnip.snippet
    local t = lsnip.text_node
    local i = lsnip.insert_node
    local extras = require 'luasnip.extras'
    local rep = extras.rep
    local fmt = require('luasnip.extras.fmt').fmt

    lsnip.add_snippets('nix', {
      s('mkIfce', {
        t 'mkIf cfg.enable',
        i(1),
      }),
      s('mkIfcfg', {
        t 'mkIf cfg.',
        i(1),
      }),
      s('mkIfcon', {
        t 'mkIf config.',
        i(1),
      }),
      s(
        'nebcfg',
        fmt(
          [[
            with lib.nebula; let
                cfg = config.{};
            in {{
                options.{} = with types; {{
                    {}
                }};

                config = mkIf cfg.enable {{
                    {}
                }};
            }}
        ]],
          {
            i(1),
            rep(1),
            i(2),
            i(3),
          }
        )
      ),
      s(
        'nebbinds',
        fmt(
          [[
            {{
                config,
                options,
                pkgs, 
                lib,
                ...
            }}:
            {}
        ]],
          {
            i(1),
          }
        )
      ),
      s(
        'enableopt',
        fmt(
          [[
            enable = mkBoolOpt {} "Enable {}";
          ]],
          {
            i(1, 'false'),
            i(2),
          }
        )
      ),
      s(
        'optblock',
        fmt(
          [[
            options.{} = with types; {{
              {}
            }};
          ]],
          {
            i(1),
            i(2),
          }
        )
      ),
      s(
        'stropt',
        fmt(
          [[
            {} = mkOpt types.str "{}" "{}";
        ]],
          {
            i(1),
            i(2),
            i(3),
          }
        )
      ),
      s(
        'ghinput',
        fmt(
          [[
            {} = {{
                url = "github:{}";
            }};
        ]],
          {
            i(1),
            i(2),
          }
        )
      ),
    })
    lsnip.add_snippets('rust', {
      s('parse', {
        t 'parse().expect("',
        i(1),
        t '")',
      }),
      s('printthatshit', {
        t 'println!("{}", ',
        i(1),
        t ')',
      }),
      s('al_dc', {
        t '#[allow(dead_code)]',
      }),
      s('al_uuvar', {
        t '#[allow(unused_variables)]',
      }),
      s('al_uumut', {
        t '#[allow(unused_mut)]',
      }),
      s('uw', {
        t '.unwrap()',
      }),
      s('ex', {
        t 'expect("',
        i(1),
        t '")',
      }),
      s('ts', {
        t 'to_string()',
      }),
      s('as', {
        t 'as_str()',
      }),
      s('snew', {
        t 'String::new()',
      }),
      s('sfrom', {
        t 'String::from("',
        i(1),
        t '")',
      }),
    })
    vim.keymap.set({ 'i', 's' }, '<Right>', function()
      if lsnip.choice_active() then
        lsnip.change_choice(1)
      end
    end)

    vim.keymap.set({ 'i', 's' }, '<Up>', function()
      if lsnip.expand_or_jumpable() then
        lsnip.expand_or_jump()
      end
    end, { silent = true })

    vim.keymap.set({ 'i', 's' }, '<Down>', function()
      if lsnip.jumpable(-1) then
        lsnip.jump(-1)
      end
    end, { silent = true })
  end,
}
