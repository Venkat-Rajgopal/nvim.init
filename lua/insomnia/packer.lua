vim.cmd [[packadd packer.nvim]]

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

end)
