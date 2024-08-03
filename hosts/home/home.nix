{ lib, pkgs, ... }: {
  imports = [ ../../modules/home-manager ./hyprland ];

  xdg.configFile.hypr = {
    enable = true;
    source = ./hackerman-wallpapers.jpg;
    target = "hypr/hackerman-wallpapers.jpg";
  };

  programs.waybar.settings.mainBar."hyprland/workspaces" = {
    persistent-workspaces = {
      DP-4 = [ 1 2 3 4 5 ];
      DVI-D-1 = [ 6 7 8 9 10 ];
    };
  };

  services.hypridle.settings = {
    listener = let
      keyboard-device = "compx-2.4g-receiver";
      us-layout = "0";
    in lib.mkForce [
      {
        timeout = 300;
        on-timeout =
          "hyprctl switchxkblayout ${keyboard-device} ${us-layout} && ${pkgs.hyprlock}/bin/hyprlock";
      }
      {
        timeout = 600;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
    ];
  };
}
