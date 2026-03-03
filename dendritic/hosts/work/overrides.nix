{
  flake.modules.homeManager.work-overrides = { pkgs, ... }: {
    home.packages = with pkgs; [ zoom-us slack signal-desktop ];

    wayland.windowManager.hyprland.settings.workspace = let
      left = "DP-1";
      right = "HDMI-A-1";
    in [
      # left
      "1, monitor:${left}, default:true"
      "2, monitor:${left}, persistent:true"
      "3, monitor:${left}, persistent:true"
      "4, monitor:${left}, persistent:true"
      "5, monitor:${left}, persistent:true"

      # right
      "6, monitor:${right}, default:true"
      "7, monitor:${right}, persistent:true"
      "8, monitor:${right}, persistent:true"
      "9, monitor:${right}, persistent:true"
      "10, monitor:${right}, persistent:true"
    ];
  };
}
