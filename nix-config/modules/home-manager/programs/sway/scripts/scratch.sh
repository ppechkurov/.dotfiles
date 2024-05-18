#!/usr/bin/env bash

main() {
	app_id=$1
	cwd="${HOME}/.dotfiles"

	swaymsg \[app_id=${app_id}\] scratchpad show,move position center,resize set width 80ppt height 80ppt ||
		swaymsg \[app_id=${app_id}\] move scratchpad ||
		exec foot \
			--app-id ${app_id} \
			--override colors.alpha=0.82 \
			--window-size-chars 120x30 \
			--working-directory ${cwd}
}

main "$@"
