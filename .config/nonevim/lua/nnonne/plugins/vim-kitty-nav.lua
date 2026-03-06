return {
	"knubie/vim-kitty-navigator",
	cmd = {
		"KittyNavigateLeft",
		"KittyNavigateRight",
		"KittyNavigateUp",
		"KittyNavigateDown",
	},
	build = "cp ./*.py ~/.config/kitty/",
}
