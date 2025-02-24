-- LSP config
-- Setup language servers.
local proc_pid = vim.fn.getpid()
local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require('lspconfig')
local servers = { 'yamlls', 'pyright', 'gopls', 'cmake', 'clangd' }
local sysos = vim.loop.os_uname().sysname
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- need to run: npm i -g yaml-language-server @volar/vue-language-server pyright vscode-langservers-extracted
-- brew install lua-language-server
-- need to run npm i -D typescript for vue project
-- check
for _, lsp in ipairs(servers) do
    local lsp_item = lspconfig[lsp]
    if lsp_item then
        lsp_item.setup {
            -- on_attach = my_custom_on_attach,
            capabilities = capabilities,
        }
    end
end

-- require 'lspconfig'.volar.setup {
--   filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' }
-- }

require 'lspconfig'.jsonls.setup {
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
        }
    }
}

local omnishparp_on_attach = function(client, bufnr) 
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end


require 'lspconfig'.omnisharp.setup {
    enable_editorconfig_support = true,
    enable_roslyn_analyzers     = true,
    enable_import_completion    = true,
    organize_imports_on_format = true,
    sdk_include_prereleases     = false,
    on_attach = omnishparp_on_attach, 
    capabilities = capabilities,
    handlers = {
        ["textDocument/definition"] = require('omnisharp_extended').handler,
    },
    cmd = {
        'OmniSharp',
        '--languageserver',
        tostring(proc_pid),
    }
}

-- load mason
require("mason").setup()
if string.find(sysos, "Windows") then
    -- load manson-lspconfig for windows
    require("mason-lspconfig").setup()
end

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'fm', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})

-- nvim-cmp setup
local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local cmp = require 'cmp'
local luasnip = require('luasnip')

local capabilities = vim.lsp.protocol.make_client_capabilities()
require('cmp_nvim_lsp').defalt_capabilities = capabilities
vim.o.completeopt = 'menuone,noselect'

require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup {
    mapping = cmp.mapping.preset.insert({
        ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
        ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
    },
    snippet = {
        expand = function(args)
            require 'luasnip'.lsp_expand(args.body)
        end
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
}

-- autoformat setup
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.go", "*.c", "*.cpp", "*.h", "*.hpp", "*.cs", "*.rs", },
    callback = function()
        vim.lsp.buf.format{ async = true }
    end,
})

-- clangd
require("clangd_extensions").setup {
    server = {
        -- options to pass to nvim-lspconfig
        -- i.e. the arguments to require("lspconfig").clangd.setup({})
    },
    extensions = {
        -- defaults:
        -- Automatically set inlay hints (type hints)
        autoSetHints = true,
        -- These apply to the default ClangdSetInlayHints command
        inlay_hints = {
            -- Only show inlay hints for the current line
            only_current_line = false,
            -- Event which triggers a refersh of the inlay hints.
            -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
            -- not that this may cause  higher CPU usage.
            -- This option is only respected when only_current_line and
            -- autoSetHints both are true.
            only_current_line_autocmd = "CursorHold",
            -- whether to show parameter hints with the inlay hints or not
            show_parameter_hints = true,
            -- prefix for parameter hints
            parameter_hints_prefix = "<- ",
            -- prefix for all the other hints (type, chaining)
            other_hints_prefix = "=> ",
            -- whether to align to the length of the longest line in the file
            max_len_align = false,
            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,
            -- whether to align to the extreme right or not
            right_align = false,
            -- padding from the right if right_align is true
            right_align_padding = 7,
            -- The color of the hints
            highlight = "Comment",
            -- The highlight group priority for extmark
            priority = 100,
        },
        ast = {
            -- These are unicode, should be available in any font
            role_icons = {
                 type = "🄣",
                 declaration = "🄓",
                 expression = "🄔",
                 statement = ";",
                 specifier = "🄢",
                 ["template argument"] = "🆃",
            },
            kind_icons = {
                Compound = "🄲",
                Recovery = "🅁",
                TranslationUnit = "🅄",
                PackExpansion = "🄿",
                TemplateTypeParm = "🅃",
                TemplateTemplateParm = "🅃",
                TemplateParamObject = "🅃",
            },
            --[[ These require codicons (https://github.com/microsoft/vscode-codicons)
            role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
            },

            kind_icons = {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = "",
            }, ]]

            highlights = {
                detail = "Comment",
            },
        },
        memory_usage = {
            border = "none",
        },
        symbol_info = {
            border = "none",
        },
    },
}

-- rust config
local rt = require("rust-tools")
rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})
-- LSP Diagnostics Options Setup 
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = ''})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = ''})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- lua lsp
lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          'vim',
          'require'
        },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
-- clipboard support
if vim.g.neovide then
  vim.g.neovide_input_use_logo = 1
  vim.keymap.set('n', '<c-s>', ':w<CR>') -- Save
  vim.keymap.set('n', '<S-Insert>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<S-Insert', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<S-Insert>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<S-Insert>', '<ESC>l"+Pli') -- Paste insert mode
  -- Allow clipboard copy paste in neovim
  vim.api.nvim_set_keymap('', '<S-Insert>', '+p<CR>', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('!', '<S-Insert>', '<C-R>+', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('t', '<S-Insert>', '<C-R>+', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('v', '<S-Insert>', '<C-R>+', { noremap = true, silent = true})
end

local status, ts = pcall(require, "nvim-treesitter.configs")
if (not status) then return end

ts.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  ensure_installed = {
    "tsx",
    "json",
    "css",
    "html",
    "lua"
  },
  autotag = {
    enable = true,
  },
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

local status, autotag = pcall(require, "nvim-ts-autotag")
if (not status) then return end
autotag.setup({})

local status, autopairs = pcall(require, "nvim-autopairs")
if (not status) then return end
autopairs.setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})
local get_os = function()
    local os_name = vim.loop.os_uname().sysname
    if os_name == "Linux" then
        return "Linux"
    elseif os_name == "Darwin" then
        return "Mac"
    elseif os_name == "Windows" then
        return "Windows"
    end
end

if vim.g.neovide then
    local neovide_toggle_fullscreen = function()
        local current_status = vim.g.neovide_fullscreen
        local target_status = current_status
        if current_status then
            target_status = false
        else
           target_status = true
        end
        vim.g.neovide_fullscreen = target_status
    end
    local gvim_font_size = os.getenv("GVIM_FONT_SIZE") or "h11"
    if get_os() == "Mac" then
        gvim_font_size = os.getenv("GVIM_FONT_SIZE") or "h16"
    end
    vim.o.guifont = "ComicShannsMono Nerd Font:" .. gvim_font_size
    vim.keymap.set('n', '<C-F11>', neovide_toggle_fullscreen)
end

-- telescope
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
vim.keymap.set('n', '<leader>bl', telescope_builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})
vim.keymap.set('n', '<leader>sl', telescope_builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>si', telescope_builtin.lsp_implementations, {})

-- setup spell checker
vim.opt.spell = true
vim.opt.spelllang = 'en_us'
vim.opt.spellfile = (os.getenv("HOME") or "~") .. '/.vim_runtime/spell/en.utf-8.add'

