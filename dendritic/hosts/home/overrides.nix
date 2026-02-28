{
  flake.modules.homeManager.home-overrides = let
    HP = "DP-4";
    samsung = "DVI-D-1";
  in {
    wayland.windowManager.hyprland.settings.workspace = [
      # left
      "1, monitor:${HP}, default:true"
      "2, monitor:${HP}, persistent:true"
      "3, monitor:${HP}, persistent:true"
      "4, monitor:${HP}, persistent:true"
      "5, monitor:${HP}, persistent:true"

      # right
      "6, monitor:${samsung}, default:true"
      "7, monitor:${samsung}, persistent:true"
      "8, monitor:${samsung}, persistent:true"
      "9, monitor:${samsung}, persistent:true"
      "10, monitor:${samsung}, persistent:true"
    ];

    programs.waybar.settings.mainBar."hyprland/workspaces" = {
      persistent-workspaces = {
        ${HP} = [ 1 2 3 4 5 ];
        ${samsung} = [ 6 7 8 9 10 ];
      };
    };
  };
}
