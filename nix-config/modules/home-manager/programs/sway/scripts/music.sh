#!/usr/bin/env bash

main() {
	app_id=${1:-float_music}
	player=${2:-ncmpcpp}

	swaymsg \[app_id=${app_id}\] kill ||
		exec foot \
			--app-id ${app_id} \
			--override colors.alpha=0.82 \
			--window-size-chars 120x20 \
			${player}
}

main "$@"
