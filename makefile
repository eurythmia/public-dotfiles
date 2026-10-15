all:
	mkdir -p  ~/.vim_viewdir
	mkdir -p ~/.vim_swapfiles
	mkdir -p ~/.vim_backups
	stow --verbose --target=$$HOME --restow */

delete:
	rm -rf ~/.vim_viewdir
	rm -rf ~/.vim_swapfiles
	rm -rf ~/.vim_backups
	stow --verbose --target=$$HOME --delete */
