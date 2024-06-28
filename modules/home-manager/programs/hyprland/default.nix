{ pkgs, ... }:
let music = pkgs.writeScriptBin "music" (builtins.readFile ./scripts/music.sh);
in {
  imports = [ ./hyprlock.nix ./workspaces.nix ./keybindings.nix ./rules.nix ]
    ++ [ ./input.nix ];

  home.packages = with pkgs; [ wf-recorder wl-clipboard xdg-utils music ];

  services.hyprpaper.enable = true;
  services.hyprpaper.settings = {
    ipc = "on";
    splash = true;
    splash_offset = 2.0;
    preload = [ "~/.config/hypr/hackerman-wallpapers.jpg" ];
    wallpaper = [ ",~/.config/hypr/hackerman-wallpapers.jpg" ];
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.xwayland.enable = true;
  wayland.windowManager.hyprland.systemd.variables = [ "--all" ];
  wayland.windowManager.hyprland.settings = {
    env = [ "QT_WAYLAND_DISABLE_WINDOWDECORATION,1" ];

    exec-once = [
      "pkill waybar; sleep 0.5; waybar"
      "sleep 1 && telegram-desktop"
      "sleep 1 && skypeforlinux"
      "sleep 1 && slack"
    ];

    "$mod" = "SUPER";

    general = {
      gaps_in = 5;
      gaps_out = 5;
      border_size = 2;
      allow_tearing = true;
      resize_on_border = true;
    };

    decoration = {
      rounding = 3;
      drop_shadow = false;
      blur = {
        enabled = true;
        # brightness = 0.5;
        brightness = 0.8;
        contrast = 0.8;
        noise = 1.0e-2;

        # vibrancy = 0.2;
        # vibrancy_darkness = 0.5;

        passes = 3;
        size = 5;

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
      disable_hyprland_logo = true;

      # no focus for special workspaces without this
      # see https://github.com/hyprwm/Hyprland/discussions/6037
      initial_workspace_tracking = 0;

      force_default_wallpaper = 0;
      hide_cursor_on_key_press = true;

      # disable dragging animation
      animate_mouse_windowdragging = false;

      # enable variable refresh rate (effective depending on hardware)
      vrr = 1;

      # we do, in fact, want direct scanout
      no_direct_scanout = false;
    };

    binds = { workspace_center_on = 0; };
  };

  # resize windows
  wayland.windowManager.hyprland.extraConfig = ''
    submap=resize

    binde=,l,resizeactive,10 0
    binde=,h,resizeactive,-10 0
    binde=,k,resizeactive,0 -10
    binde=,j,resizeactive,0 10

    bind=,escape,submap,reset
    bind=$mod,R,submap,reset

    submap=reset

    monitor=Unknown-1,disabled
  '';
  # https://wiki.hyprland.org/FAQ/#workspaces-or-clients-are-disappearing-or-monitor-related-dispatchers-cause-crashes
}
