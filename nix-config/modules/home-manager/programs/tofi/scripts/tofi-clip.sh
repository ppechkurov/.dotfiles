#!/usr/bin/env bash

cliphist list |
	tofi \
		--require-match false \
		--prompt-text "copy: " \
		--config "$HOME/.config/tofi/one-line" |
	cliphist decode "$selected" |
	wl-copy
