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

end)
