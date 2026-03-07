{
  flake.modules.homeManager.home = let
    HP = "DP-4";
    samsung = "DVI-D-1";
    TV = "HDMI-A-4";
  in {
    wayland.windowManager.hyprland.settings.monitor = [
      "${HP}, preferred, 0x0, 1"
      "${samsung}, preferred, 1920x0, 1"
      "${TV}, preferred, 0x-1080, 1"
    ];

    wayland.windowManager.hyprland.settings.workspace = [
      # left
      "1, monitor:${HP}, persistent:true, default:true"
      "2, monitor:${HP}, persistent:true"
      "3, monitor:${HP}, persistent:true"
      "4, monitor:${HP}, persistent:true"
      "5, monitor:${HP}, persistent:true"

      # right
      "6, monitor:${samsung}, persistent:true, default:true"
      "7, monitor:${samsung}, persistent:true"
      "8, monitor:${samsung}, persistent:true"
      "9, monitor:${samsung}, persistent:true"
      "10, monitor:${samsung}, persistent:true"
    ];
  };
}
