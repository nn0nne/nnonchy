return {
	"windwp/nvim-ts-autotag",
	ft = { "html", "tsx", "jsx", "vue", "svelte" },
	config = function()
		require("nvim-ts-autotag").setup({
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = false,
			},
		})
	end,
}
