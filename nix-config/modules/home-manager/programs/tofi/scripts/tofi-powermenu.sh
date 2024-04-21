#!/usr/bin/env bash

lock="󰍁 Lock"
shutdown=" Shutdown"
reboot=" Reboot"
suspend="󰤄 Suspend"
logout="󰗽 Logout"
options="$lock\n$shutdown\n$reboot\n$suspend\n$logout"

selected="$(echo -e "$options" |
	tofi \
		--prompt-text "" \
		--padding-top "30%" \
		--padding-left "45%" \
		--config "$HOME/.config/tofi/multi-line")"

case $selected in
"$shutdown")
	systemctl poweroff --check-inhibitors=no
	;;
"$reboot")
	systemctl reboot
	;;
"$suspend")
	# Hold all on RAM
	systemctl suspend
	;;
"$logout")
	if [[ "$XDG_SESSION_DESKTOP" == 'sway' ]]; then
		swaymsg exit
	fi
	if [[ "$XDG_SESSION_DESKTOP" == 'Hyprland' ]]; then
		hyprctl dispatch exit
	fi
	if [[ "$XDG_SESSION_DESKTOP" == 'dwl' ]]; then
		# simulate logo + ctrl + shift + q key press
		ydotool key 125:1 29:1 42:1 16:1 16:0 42:0 29:0 125:0
	fi

	systemctl --user stop graphical-session.target
	systemctl --user stop wayland-session.target
	;;
"$lock")
	/etc/scripts/sway-lock.sh
	;;
esac
