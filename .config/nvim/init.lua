-- auto install vim-plug and plugins, if not found
local data_dir = vim.fn.stdpath('data')
if vim.fn.empty(vim.fn.glob(data_dir .. '/site/autoload/plug.vim')) == 1 then
	vim.cmd('silent !curl -fLo ' .. data_dir .. '/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
	vim.o.runtimepath = vim.o.runtimepath
	vim.cmd('autocmd VimEnter * PlugInstall --sync | source $MYVIMRC')
end

local vim = vim
local Plug = vim.fn['plug#']
vim.call('plug#begin')

Plug('neovim/nvim-lspconfig')

Plug ('hrsh7th/cmp-nvim-lsp' )
Plug ('hrsh7th/cmp-buffer'   )
Plug ('hrsh7th/cmp-path'     )
Plug ('hrsh7th/cmp-cmdline'  )
Plug ('hrsh7th/nvim-cmp'     )

-- For vsnip users.
Plug ('hrsh7th/cmp-vsnip')
Plug ('hrsh7th/vim-vsnip')

Plug('catppuccin/nvim', { ['as'] = 'catppuccin' }) --colorscheme
Plug('nvim-lualine/lualine.nvim') --statusline

Plug('nvim-tree/nvim-web-devicons') --pretty icons
Plug('lewis6991/gitsigns.nvim') --git
Plug('romgrk/barbar.nvim') --bufferline

Plug('nvim-treesitter/nvim-treesitter') --improved syntax
Plug('mfussenegger/nvim-lint') --async linter
Plug('nvim-tree/nvim-tree.lua') --file explorer

Plug('windwp/nvim-autopairs') --autopairs 
Plug('numToStr/Comment.nvim') --easier comments
Plug('norcalli/nvim-colorizer.lua') --color highlight
Plug('ibhagwan/fzf-lua') --fuzzy finder and grep
Plug('numToStr/FTerm.nvim') --floating terminal
--Plug('folke/which-key.nvim') --mappings popup

vim.call('plug#end')

-- THEME STUFF

---- MAPPINGS ----
local function map(m, k, v)
	vim.keymap.set(m, k, v, { noremap = true, silent = true })
end

-- set leader
map("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

map("n", "<leader>w", ":w<CR>")
map("n", "<leader>q", ":q<CR>")
map("n", "<leader>1", ":q!<CR>")
map("n", "<leader>x", ":wq<CR>")
map("n", "<leader>t", ":NvimTreeToggle<CR>") --open file explorer
map("n", "<leader>s", ":source %<CR>") --reload neovim config

map('n', '<leader>\\', ':vsplit<CR>:bnext<CR>') --ver split + open next buffer
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")

-- Error debugging lint/lsp maps
map("n", "<leader>e", vim.diagnostic.open_float)
map("n", "<leader>]", vim.diagnostic.goto_next)
map("n", "<leader>[", vim.diagnostic.goto_prev)
map("n", "<leader>c", vim.diagnostic.setloclist)

--map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")

map('n', '<leader>`', ":lua require('FTerm').open()<CR>") --open term
map('t', '<Esc>', '<C-\\><C-n><CMD>lua require("FTerm").close()<CR>') --preserves session

map('n', 'U', '<C-r>') -- redo
map("i", "jk", "<Esc>")

map("n", "<S-j>", "}")
map("n", "<S-k>", "{")

-- repeat previous f, t, F or T movement
--vim.keymap.set('n', '\'', ';')

-- paste without overwriting
--vim.keymap.set('v', 'p', 'P')

---- OPTIONS ----
local options = {
	laststatus = 3, --you can now have statusline per neovim instance
	ruler = false, --disable extra numbering
	showmode = false, --not needed due to lualine
	showcmd = false,
	cmdheight = 0,
	wrap = true, --toggle bound to leader W
	mouse = "a", --enable mouse
	clipboard = "unnamedplus", --system clipboard integration
	history = 100, --command line history
	swapfile = false, --swap just gets in the way, usually
	backup = false,
	undofile = true, --undos are saved to file
	cursorline = true, --highlight line
	ttyfast = true, --faster scrolling
	smoothscroll = true,
	--title = true, --automatic window titlebar

	number = true, --numbering lines
	--relativenumber = true, --toggle bound to leader nn
	--numberwidth = 4,

	smarttab = true, --indentation stuff
	--cindent = true,
	autoindent = false,
	tabstop = 2, --visual width of tab
	shiftwidth = 2,

	foldmethod = "expr",
	foldlevel = 99, --disable folding, lower #s enable
	foldexpr = "nvim_treesitter#foldexpr()",

	termguicolors = true,

	ignorecase = true, --ignore case while searching
	smartcase = true, --but do not ignore if caps are used

	conceallevel = 2, --markdown conceal
	concealcursor = "nc",

	splitkeep = 'screen', --stablizie window open/close
}


for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.opt.signcolumn = "yes"  -- always show the sign column for warning/errors

vim.diagnostic.config({
	virtual_text = {
		spacing = 4,
		prefix = '●', -- or '', if you want nothing
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		focusable = false,
		header = "",
		prefix = "",
		source = "always",
	},
})


-- AUTOCMD --
-- linting when file is written to
vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function()
		-- try_lint without arguments runs the linters defined in `linters_by_ft`
		-- for the current filetype, on write
		require("lint").try_lint()
	end,
})

-- spellcheck in md
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	command = "setlocal spell wrap",
})


-- disable automatic comment on newline
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- Remember cursor position from last session
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = vim.api.nvim_create_augroup("remember_cursor_position", { clear = true }),
	callback = function()
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.cmd("normal! g`\"")
			vim.cmd("normal! zz")
		end
	end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
	callback = function()
		vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#001b42' })
		vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = '#001b42', bold = true })
		--vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#001c33' })
	end,
})

vim.api.nvim_create_autocmd('InsertEnter', {
	callback = function()
		vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#001b42' })
		vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#aaff22', bg = '#001b42', bold = true })
	end,
})

-- Create an augroup to manage the autocommands
vim.api.nvim_create_augroup('VisualModeHighlight', { clear = true })

-- Detect entering Visual mode
vim.api.nvim_create_autocmd('ModeChanged', {
	group = 'VisualModeHighlight',
	pattern = '*:[vV\x16]*',
	callback = function()
		-- Set the CursorLine highlight for Visual mode
		vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#000000' })
		vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#e45dea',  bold = true })
		-- set cursor itself too
	end,
})

-- Detect leaving Visual mode
vim.api.nvim_create_autocmd('ModeChanged', {
	group = 'VisualModeHighlight',
	pattern = '[vV\x16]*:*',
	callback = function()
		-- Revert the CursorLine highlight to default
		vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#001b42' })
		vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = '#001b42' }) -- Replace with your default color
	end,
})

-- #000945

-- useful regex delete all lines that do not begin with     "+-"     :g!/^[+-]/d

require("plugins.autopairs")
require("plugins.colorizer")
--require("plugins.colorscheme")
vim.cmd.colorscheme "unokai"

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })  -- Inherits terminal BG
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#001b42' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = '#001c33', bold = true })

vim.cmd("highlight WinSeparator guifg=#12b38e guibg=#000000")

-- Dark-themed barbar.nvim
-- Active tab
vim.api.nvim_set_hl(0, "BufferCurrent", { fg = "#12b000",bg = "#1b1919"})
-- Inactive tabs
--vim.api.nvim_set_hl(0, "NormalNC", { bg = "#000000", fg = "#555555" })
--vim.api.nvim_set_hl(0, "BufferInactive", { fg = "#777777", bg = "#000000" })
-- Icons
--vim.api.nvim_set_hl(0, "BufferCurrentIcon", { fg = "#000000", bg = "#000000" })
-- Separators
--vim.api.nvim_set_hl(0, "BufferSeparator", { fg = "#000000", bg = "#000000" })
-- For the entire tab bar's background (behind all tabs):
vim.api.nvim_set_hl(0, "BufferTabpageFill", { bg = "#000000" })  -- Pure black

require("plugins.barbar")
require("plugins.evil_lualine")
--require("plugins.lualine")
require("plugins.nvim-lint")

require("plugins.comment")
require("plugins.fterm")
require("plugins.fzf-lua")
require("plugins.gitsigns")
require("plugins.nvim-tree")
require("plugins.treesitter")
--require("plugins.which-key")
--load_theme()

-- Built-in LSP basic setup
local lspconfig = require('lspconfig')

-- Example: TypeScript/JavaScript
--lspconfig.tsserver.setup {}

-- Example: Python
lspconfig.pylsp.setup {}

-- Example: Lua
lspconfig.lua_ls.setup {
	settings = {
		Lua = {
			diagnostics = { globals = {'vim', 'nvim' } }
		}
	}
}


local cmp = require'cmp'

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<Tab>'] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end,
		['<S-Tab>'] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end,
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), 
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' }, 
	}, {
		{ name = 'buffer' },
	})
})
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	}),
	matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig').lua_ls.setup {
	capabilities = capabilities
}

