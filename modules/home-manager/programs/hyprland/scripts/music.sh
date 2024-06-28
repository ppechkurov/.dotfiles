#!/usr/bin/env bash

main() {
	app_id=${1:-music}
	player=${2:-ncmpcpp}
	session=${3:-music}

	if ! tmux has-session -t "${session}" 2>/dev/null; then
		tmux new-session -ds "${session}" "${player}" \; split-window -v -p 20 cava \; select-pane -t 1
	fi

	exec foot \
		--app-id "${app_id}" \
		--override colors.alpha=0.1 \
		tmux attach-session -t "${session}"
}

main "$@"
