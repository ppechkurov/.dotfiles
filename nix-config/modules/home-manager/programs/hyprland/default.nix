{ pkgs, config, lib, ... }:
let music = pkgs.writeScriptBin "music" (builtins.readFile ./scripts/music.sh);
in {
  home.packages = with pkgs; [
    playerctl
    wf-recorder
    wl-clipboard
    xdg-utils
    music
  ];

  services.hyprpaper.enable = true;
  services.hyprpaper.settings = {
    ipc = "on";
    splash = true;
    splash_offset = 2.0;
    preload = [ "~/.config/hypr/hackerman-wallpapers.jpg" ];
    wallpaper = [ ",~/.config/hypr/hackerman-wallpapers.jpg" ];
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = let
    opacity = "0.82";
    cwd = "${config.home.homeDirectory}/.dotfiles";
    scratch_term_cmd =
      "foot --app-id scratch --override colors.alpha=${opacity} --working-directory ${cwd}";
  in {
    "$mod" = "SUPER";
    env = [ "QT_WAYLAND_DISABLE_WINDOWDECORATION,1" ];

    exec-once = [
      "waybar"
      "telegram-desktop"
      "[workspace special:scratch silent] ${scratch_term_cmd}"
      "[workspace special:music silent] music"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"
    ];

    bind = import ./keybindings.nix {
      inherit lib;
      inherit pkgs;
    };

    workspace = import ./workspaces.nix;
    windowrulev2 = import ./rules.nix;
    input = import ./input.nix;

    general = {
      gaps_in = 5;
      gaps_out = 5;
      border_size = 2;
      allow_tearing = true;
      resize_on_border = true;
      cursor_inactive_timeout = 3;
      layout = "master";
    };

    decoration = {
      rounding = 3;
      drop_shadow = false;
      blur = {
        enabled = true;
        brightness = 0.5;
        # brightness = 1.0;
        contrast = 1.0;
        noise = 1.0e-2;

        vibrancy = 0.2;
        vibrancy_darkness = 0.5;

        passes = 4;
        size = 7;

        popups = true;
        popups_ignorealpha = 0.2;
      };
    };

    animations = {
      enabled = true;
      animation = [
        "border, 1, 5, default"
        "fade, 1, 5, default"
        "windows, 1, 2, default, popin 80%"
        "workspaces, 1, 2, default, slide"
        "specialWorkspace, 1, 3, default, slidevert"
      ];
    };

    misc = {
      # disable auto polling for config file changes
      disable_autoreload = true;

      force_default_wallpaper = 0;

      # disable dragging animation
      animate_mouse_windowdragging = false;

      # enable variable refresh rate (effective depending on hardware)
      vrr = 1;

      # we do, in fact, want direct scanout
      no_direct_scanout = false;
    };

    binds = { workspace_center_on = 1; };
  };
}
