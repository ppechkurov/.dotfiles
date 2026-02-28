#!/usr/bin/env bash

# credits to ThePrimeagen.
# [link](https://github.com/ThePrimeagen/.dotfiles/blob/602019e902634188ab06ea31251c01c1a43d1621/bin/.local/scripts/tmux-sessionizer)

if [[ $# -eq 1 ]]; then
  selected=$1
else
  selected=$(find ~/projects ~/projects/go ~/ -mindepth 1 -maxdepth 1 -type d | fzf --tmux)
fi

if [[ -z $selected ]]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr . _)

if [[ -z $TMUX ]]; then
  tmux new-session -A -s "$selected_name" -c "$selected" # attach if exists, create if not
  exit 0
fi

if ! tmux has-session -t "$selected_name" 2>/dev/null; then
  tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"
