local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local lazy = require("lazy")

lazy.setup({
	spec = {
		{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
		{ "tpope/vim-fugitive" },
		{ "mfussenegger/nvim-lint" },
		{ "github/copilot.vim" },
		{
			"folke/snacks.nvim",
			priority = 1000,
			lazy = false,
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},
		{
			"rose-pine/neovim",
			name = "rose-pine",
			config = function()
				vim.cmd("colorscheme rose-pine")
			end,
		},
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8",
			-- or                              , branch = '0.1.x',
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{
			"ThePrimeagen/harpoon",
			branch = "harpoon2",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{ "nvim-lua/plenary.nvim" },
		{
			"nvim-treesitter/nvim-treesitter",
			branch = "master",
			lazy = false,
			build = ":TSUpdate",
		},
		{
			"stevearc/conform.nvim",
			opts = {},
		},
		{ "VonHeikemen/lsp-zero.nvim", branch = "v4.x" },
		{ "neovim/nvim-lspconfig" },
		{ "hrsh7th/nvim-cmp" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		{
			"nvimtools/none-ls.nvim",
			config = function()
				require("null-ls").setup()
			end,
			requires = { "nvim-lua/plenary.nvim" },
		},
	},

	install = { colorscheme = { "rose-pine" } },
	checker = {
		enabled = true,
		notify = false,
		frequency = 24 * 60 * 60, -- check for updates once a day
	},
})

local AUTO_UPDATE_INTERVAL = 24 * 60 * 60
local auto_update_marker = vim.fs.normalize(vim.fn.stdpath("state") .. "/lazy/auto-update.txt")

local function write_last_auto_update()
	local dir = vim.fn.fnamemodify(auto_update_marker, ":h")
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end
	vim.fn.writefile({ tostring(os.time()) }, auto_update_marker)
end

local function needs_auto_update()
	local ok, data = pcall(vim.fn.readfile, auto_update_marker)
	if not ok or vim.tbl_isempty(data) then
		return true
	end
	local last = tonumber(data[1])
	if not last then
		return true
	end
	return (os.time() - last) >= AUTO_UPDATE_INTERVAL
end

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		if not needs_auto_update() then
			return
		end

		vim.schedule(function()
			local runner = lazy.update({ show = false })
			if runner and runner.wait then
				runner:wait(function()
					write_last_auto_update()
				end)
			else
				write_last_auto_update()
			end
		end)
	end,
})
