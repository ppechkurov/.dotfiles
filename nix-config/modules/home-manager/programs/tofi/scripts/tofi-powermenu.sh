#!/usr/bin/env bash

lock="󰍁 Lock"
shutdown=" Shutdown"
reboot=" Reboot"
# suspend="󰤄 Suspend"
logout="󰗽 Logout"
options="$lock\n$shutdown\n$reboot\n$logout"

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
# "$suspend")
# 	# Hold all on RAM
# 	systemctl suspend
# 	;;
"$logout")
	swaymsg exit
	systemctl --user stop graphical-session.target
	systemctl --user stop wayland-session.target
	;;
"$lock")
	swaylock --daemonize --image "$HOME/.config/sway/hackerman-wallpapers.jpg" --ignore-empty-password
	;;
esac
