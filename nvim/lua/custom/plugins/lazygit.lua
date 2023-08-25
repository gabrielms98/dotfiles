return {
'kdheepak/lazygit.nvim',
	config = function()
		vim.keymap.set("n", "lg", ":LazyGit<CR>")
	end
}
