{ ... }: {
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
}
