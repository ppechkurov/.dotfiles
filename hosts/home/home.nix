{ lib, config, pkgs, ... }: {
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
  home.sessionPath = [ "$HOME/go/bin" ];

  programs.zathura.enable = true;

  xdg.configFile."zathura/zathurarc" = {
    enable = true;
    recursive = true;
    source = config.lib.file.mkOutOfStoreSymlink ./zathurarc;
    # "${config.home.homeDirectory}/.dotfiles/hosts/home/zathurarc";
  };

  # programs.zathura.options = {
  #   font = "JetBrainsMono Nerd Font 11";
  #   window-title-basename = true;
  #   selection-clipboard = "clipboard";
  #   adjust-open = "best-fit";
  #   pages-per-row = 1;
  #   scroll-page-aware = true;
  #   scroll-full-overlap = 1.0e-2; # Fixed decimal format
  #   scroll-step = 50;
  #   zoom-min = 10;
  #   guioptions = "none";
  #
  #   # Zenbones Dark Colors
  #   notification-error-bg = "#191919";
  #   notification-error-fg = "#de6e7c";
  #   notification-warning-bg = "#191919";
  #   notification-warning-fg = "#d68c67";
  #   notification-bg = "#191919";
  #   notification-fg = "#b7c5d3";
  #
  #   completion-bg = "#2c2c2c";
  #   completion-fg = "#b7c5d3";
  #   completion-group-bg = "#191919";
  #   completion-group-fg = "#819b69";
  #   completion-highlight-bg = "#6099c0";
  #   completion-highlight-fg = "#191919";
  #
  #   index-bg = "#191919";
  #   index-fg = "#b7c5d3";
  #   index-active-bg = "#6099c0";
  #   index-active-fg = "#191919";
  #
  #   inputbar-bg = "#2c2c2c";
  #   inputbar-fg = "#b7c5d3";
  #
  #   statusbar-bg = "#2c2c2c";
  #   statusbar-fg = "#b7c5d3";
  #
  #   highlight-color = "#d68c67";
  #   highlight-active-color = "#819b69";
  #
  #   default-bg = "#191919";
  #   default-fg = "#b7c5d3";
  #   render-loading = true;
  #   render-loading-bg = "#191919";
  #   render-loading-fg = "#b7c5d3";
  #
  #   # recolor-lightcolor = "#191919";
  #   # recolor-darkcolor = "#b7c5d3";
  #   # recolor = true;
  #   # recolor-keephue = true;
  #   # recolor-reverse-video = true;
  #
  #   # smooth-scroll = true;
  # };

  programs.atuin.enable = true;

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
        timeout = 6000;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
    ];
  };
}
