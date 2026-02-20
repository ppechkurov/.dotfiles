{
  flake.modules.homeManager.home-overrides = {
    programs.waybar.settings.mainBar."hyprland/workspaces" = {
      persistent-workspaces = {
        DP-4 = [ 1 2 3 4 5 ];
        DVI-D-1 = [ 6 7 8 9 10 ];
      };
    };
  };
}
