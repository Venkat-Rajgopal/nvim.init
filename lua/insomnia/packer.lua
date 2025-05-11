-- Auto-install Packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    print("⏳ Installing packer.nvim...")
    fn.system({
      "git",
      "clone",
      "--depth", "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })
    vim.cmd([[packadd packer.nvim]])
    print("✅ packer.nvim installed")
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()


return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.8',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use { "catppuccin/nvim", as = "catppuccin" }
  use( 'nvim-treesitter/nvim-treesitter', {run = ':TSUpdate' })
  use( "nvim-tree/nvim-web-devicons" )

  -- tree
  use({
	  "nvim-tree/nvim-tree.lua",
	  requires = {
		  "nvim-tree/nvim-web-devicons",
	  },
  })
 
  -- statusline
  use({
	  "nvim-lualine/lualine.nvim",
	  requires = { "nvim-tree/nvim-web-devicons" }
  })

  --git integration
  use( 'tpope/vim-fugitive' )

  --tab style navigation
  use({
	  'akinsho/bufferline.nvim',
	  requires = 'nvim-tree/nvim-web-devicons',
  })

  -- LSP Configuration & Plugins
  use {
	  'neovim/nvim-lspconfig',
	  requires = {
		  -- Automatically install LSPs to stdpath for neovim
		  'williamboman/mason.nvim',
		  'williamboman/mason-lspconfig.nvim',

		  -- Useful status updates for LSP
		  'j-hui/fidget.nvim',

		  -- Additional lua configuration, makes nvim stuff amazing
		  'folke/neodev.nvim',
	  },
  }

  -- Autocompletion
  use {
	  'hrsh7th/nvim-cmp',
	  requires = {
		  'hrsh7th/cmp-nvim-lsp',
		  'hrsh7th/cmp-buffer',
		  'hrsh7th/cmp-path',
		  'hrsh7th/cmp-cmdline',
		  'L3MON4D3/LuaSnip',
		  'saadparwaiz1/cmp_luasnip',
	  },
  }

  -- Formatting and linting
  use 'jose-elias-alvarez/null-ls.nvim'
  
  -- some additional Plugins for markdown
  use {
	  'preservim/vim-markdown',
	  requires = 'godlygeek/tabular',
	  ft = {'markdown'}
  }

  use {
	  'iamcco/markdown-preview.nvim',
	  run = function() vim.fn["mkdp#util#install"]() end,
	  ft = {'markdown'}
  }

use { 'windwp/nvim-autopairs' }

end)
