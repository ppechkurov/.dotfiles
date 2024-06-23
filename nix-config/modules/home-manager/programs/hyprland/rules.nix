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

    "workspace 4 silent, class:org.telegram.desktop"
    "workspace 5 silent, class:Slack"
    "workspace 3, class:neovide"
    "workspace 7, class:firefox"
    "workspace 0 silent, class:Skype"
  ];
}

