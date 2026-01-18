return {
	"preservim/vim-markdown",
	ft = { "markdown" },
	config = function()
		vim.g.vim_markdown_math = 1
		vim.g.vim_markdown_folding_disabled = 1
	end,
}
