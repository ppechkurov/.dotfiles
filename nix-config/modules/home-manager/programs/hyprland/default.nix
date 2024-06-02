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

  wayland.windowManager.hyprland = { enable = true; };
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

    bind = [
      "$mod SHIFT, E, exec, pkill Hyprland"
      "$mod SHIFT, C, exec, hyprctl reload && notify-send 'Hyprland reloaded'"
      "$mod SHIFT, Q, exec, tofi-powermenu"
      "$mod, B, exec, chromium"
      "$mod, Return, exec, foot --override colors.alpha=0.10"

      "$mod, Space, togglefloating"
      "$mod, F, fullscreen"
      "$mod, D, killactive"

      ",XF86AudioMute, exec, amixer sset Master toggle"
      "$mod, F12, exec, amixer sset Master 5%+"
      "$mod, F11, exec, amixer sset Master 5%-"
      ",XF86AudioRaiseVolume, exec, amixer sset Master 5%+"
      ",XF86AudioLowerVolume, exec, amixer sset Master 5%-"

      "$mod, XF86AudioRaiseVolume, exec, amixer sset Master 1%+"
      "$mod, XF86AudioLowerVolume, exec, amixer sset Master 1%-"

      ",XF86AudioNext, exec, ${lib.getExe pkgs.playerctl} next"
      ",XF86AudioPrev, exec, ${lib.getExe pkgs.playerctl} previous"
      ",XF86AudioPlay, exec, ${lib.getExe pkgs.playerctl} play-pause"

      # move focus
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"
      "$mod, h, movefocus, l"
      "$mod, l, movefocus, r"
      "$mod, k, movefocus, u"
      "$mod, j, movefocus, d"

      # move windows
      "$mod SHIFT, h, movewindow, l"
      "$mod SHIFT, l, movewindow, r"
      "$mod SHIFT, k, movewindow, u"
      "$mod SHIFT, j, movewindow, d"

      "$mod SHIFT, dollar, movetoworkspace, special:scratch"
      "$mod, dollar, togglespecialworkspace, scratch"
      "$mod, dollar, resizeactive, exact 80% 80%"
      "$mod, dollar, centerwindow"

      "$mod SHIFT, M, movetoworkspace, special:music"
      "$mod, M, togglespecialworkspace, music"
      "$mod, M, resizeactive, exact 80% 80%"
      "$mod, M, centerwindow"

      ", Print, exec, grimblast copy area"
    ] ++ (
      # workspaces
      # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      builtins.concatLists (builtins.genList (x:
        let ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
        in [
          "$mod, ${ws}, workspace, ${toString (x + 1)}"
          "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
        ]) 10));

    input = {
      kb_layout = "us,ru,us";
      kb_variant = "dvorak,,basic";
      kb_options = "grp:alt_shift_toggle,caps:escape"; # switch layout
      repeat_delay = "250";
      repeat_rate = "45";
    };

    workspace = [
      "1, monitor:DVI-D-1, default:true"
      "2, monitor:DVI-D-1"
      "3, monitor:DVI-D-1"
      "4, monitor:DVI-D-1"
      "5, monitor:DVI-D-1"
      "6, monitor:DP-4"
      "7, monitor:DP-4, on-created-empty:chromium-browser"
      "8, monitor:DP-4"
      "9, monitor:DP-4"
      "10, monitor:DP-4"
      "6, monitor:DP-1"
      "7, monitor:DP-1, on-created-empty:chromium-browser"
      "8, monitor:DP-1"
      "9, monitor:DP-1"
      "10, monitor:DP-1"

      # "special:scratch, on-created-empty:${scratch_term_cmd}"
      # "special:music, on-created-empty:music"
    ];

    windowrulev2 = let
      scratch = "class:scratch";
      music = "class:music";
    in [
      "float, ${scratch}"
      "size 80% 80%, ${scratch}"
      "center, floating:1, ${scratch}"
      "noblur, ${scratch}"

      "float, ${music}"
      "size 80% 80%, ${music}"
      "center, floating:1, ${music}"

      "workspace 4 silent, class:org.telegram.desktop"
      "workspace 7, class:chromium-browser"
    ];
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

    general = {
      gaps_in = 5;
      gaps_out = 5;
      border_size = 2;
      # "col.active_border" = "rgba(88888888)";
      # "col.inactive_border" = "rgba(00000088)";

      allow_tearing = true;
      resize_on_border = true;
    };

    decoration = {
      rounding = 3;
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
  };
}
