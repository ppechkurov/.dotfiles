{ pkgs, config, lib, ... }:
let music = pkgs.writeScriptBin "music" (builtins.readFile ./scripts/music.sh);
in {
  programs.hyprlock.enable = true;
  programs.hyprlock.settings = {
    background = {
      monitor = "";
      path =
        "${config.home.homeDirectory}/.config/hypr/hackerman-wallpapers.jpg";
      # color = "rgba(25, 20, 20, 1.0)";
      blur_passes = 3;
      blur_size = 4;
      noise = 1.17e-2;
      contrast = 0.8916;
      brightness = 0.8172;
      vibrancy = 0.1696;
      vibrancy_darkness = 0.0;
    };

    input-field = {
      monitor = "";
      size = "200, 50";
      outline_thickness = 3;
      dots_size = 0.2;
      dots_spacing = 0.64;
      dots_center = true;
      dots_rounding = -1;
      outer_color = "rgb(151515)";
      inner_color = "rgb(200, 200, 200)";
      font_color = "rgb(10, 10, 10)";
      fade_on_empty = true;
      fade_timeout = 1000;
      placeholder_text = "<i>Input Password...</i>";
      hide_input = false;
      rounding = -1;
      check_color = "rgb(204, 136, 34)";
      fail_color = "rgb(204, 34, 34)";
      fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
      fail_transition = 300;
      capslock_color = -1;
      numlock_color = -1;
      bothlock_color = -1;
      invert_numlock = false;
      swap_font_color = false;
      position = "0, -20";
      halign = "center";
      valign = "center";
    };

    label = [{
      text = ''cmd[update:200:1] echo "<b><big> $TIME </big></b>"'';
      # text = ''cmd[update:200:1] echo "<b><big> $(date +"%H:%M:%S") </big></b>"'';
      # color = "rgb(${config.theme.colors.fg})";
      font_size = 64;

      position = "0, 16";
      halign = "center";
      valign = "center";
    }];
  };

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

    exec-once =
      [ "pkill waybar; sleep 0.5; waybar" "sleep 1 && telegram-desktop" ];

    bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];

    bind = import ./keybindings.nix {
      inherit lib;
      inherit pkgs;
    };

    workspace = import ./workspaces.nix scratch_term_cmd;
    windowrulev2 = import ./rules.nix;
    input = import ./input.nix;

    general = {
      gaps_in = 5;
      gaps_out = 5;
      border_size = 2;
      allow_tearing = true;
      resize_on_border = true;
      cursor_inactive_timeout = 3;
      # layout = "master";
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
      disable_hyprland_logo = true;

      # no focus for special workspaces without this
      # see https://github.com/hyprwm/Hyprland/discussions/6037
      initial_workspace_tracking = 0;

      force_default_wallpaper = 0;

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
  '';
}
