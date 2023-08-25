return {
	"ThePrimeagen/harpoon",
	config = function()
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		vim.keymap.set("n", "<leader>a", mark.add_file)
		vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

		vim.keymap.set(
			"n",
			"<M-n>",
			function()
				ui.nav_file(1)
			end
		)
		vim.keymap.set(
			"n",
			"<M-e>",
			function()
				ui.nav_file(2)
			end
		)
		vim.keymap.set(
			"n",
			"<M-i>",
			function()
				ui.nav_file(3)
			end
		)
		vim.keymap.set(
			"n",
			"<M-o>",
			function()
				ui.nav_file(4)
			end
		)

		require("harpoon").setup(
			{
				mark_branch = true
			}
		)
	end
}
