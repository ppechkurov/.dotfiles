#!/usr/bin/env bash

rg '^[[:space:]]*Host[[:space:]]+(\S+)' \
	-o --replace '$1' \
	~/.ssh/config \
	--no-line-number |
	tofi --prompt-text "SSH:>" --config "$HOME/.config/tofi/multi-line" |
	xargs -o ssh
