#!/usr/bin/env bash

rg "Host " ~/.ssh/config | rg -o '\S+' | sed -n '2p' |
	tofi --prompt-text "SSH:>" --config "$HOME/.config/tofi/multi-line" |
	xargs ssh
