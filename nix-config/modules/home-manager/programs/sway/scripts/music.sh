#!/usr/bin/env bash

main() {
	app_id=${1:-float_music}

	swaymsg \[app_id=${app_id}\] kill && exit 0

	player=${2:-ncmpcpp}
	session=${3:-music}

	if ! tmux has-session -t ${session} 2>/dev/null; then
		tmux new-session -ds ${session} ${player} \; split-window -v -p 25 cava \; select-pane -t 1
	fi

	exec foot \
		--app-id ${app_id} \
		--override colors.alpha=0.82 \
		tmux attach-session -t ${session}
}

main "$@"
