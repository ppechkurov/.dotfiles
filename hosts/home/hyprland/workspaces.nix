{ lib, ... }: {
  wayland.windowManager.hyprland.settings.input = {
    kb_layout = lib.mkForce "us,ru,us";
    kb_variant = "dvorak,,basic";
  };

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-4, preferred, 0x0, 1"
    "DVI-D-2, preferred, 1920x0, 1"
    "HDMI-A-4, preferred, 0x-1080, 1"
  ];

  wayland.windowManager.hyprland.settings.workspace = [
    # left
    "1, monitor:DP-4, default:true"
    "2, monitor:DP-4"
    "3, monitor:DP-4"
    "4, monitor:DP-4"
    "5, monitor:DP-4"

    # right
    "6, monitor:DVI-D-2, default:true"
    "7, monitor:DVI-D-2"
    "8, monitor:DVI-D-2"
    "9, monitor:DVI-D-2"
    "10, monitor:DVI-D-2"
  ];
}

