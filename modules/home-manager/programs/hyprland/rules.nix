{ ... }:
let
  scratch = "class:scratch";
  music = "class:music";
  pavucontrol = "class:pavucontrol";
in {
  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "float, ${scratch}"
    "size 80% 80%, ${scratch}"
    "center, floating:1, ${scratch}"
    "noblur, ${scratch}"

    "float, ${music}"
    "size 80% 80%, ${music}"
    "center, floating:1, ${music}"

    "float, ${pavucontrol}"
    "size 50% 50%, ${pavucontrol}"
    "center, floating:1, ${pavucontrol}"
    "stayfocused, ${pavucontrol}"

    "float, class:neovide"
    "size 90% 90%, class:neovide"

    "float, class:flameshot"
    # "float, class:zoom"
    # "size 90% 90%, class:zoom"
    # "center, floating:1, class:zoom"

    "workspace 1, class:default"
    "workspace 2 silent, class:firefox"
    "workspace 3, class:neovide"
    "workspace 4 silent, class:org.telegram.desktop"
    "workspace 5 silent, class:Slack"
    "workspace 6 silent, class:ssh"

    "workspace 10 silent, class:Skype"
  ];
}

