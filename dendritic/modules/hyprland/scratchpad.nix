{
  flake.modules.homeManager.hyprland = { config, ... }:
    let scratch = "class:scratch";
    in {
      wayland.windowManager.hyprland.settings.windowrulev2 = [
        "float, ${scratch}"
        "size 80% 80%, ${scratch}"
        "center, floating:1, ${scratch}"
        "noblur, ${scratch}"
      ];

      wayland.windowManager.hyprland.settings.bind = [
        "$mod SHIFT, dollar, movetoworkspace, special:scratch"
        "$mod, dollar, togglespecialworkspace, scratch"
        "$mod, dollar, resizewindowpixel, exact 80% 80%, ${scratch}"
        "$mod, dollar, centerwindow"

        "$mod, M, togglespecialworkspace, music"
        "$mod, M, resizewindowpixel, exact 80% 80%, org.jellyfin.JellyfinDesktop"
        "$mod, M, centerwindow"
      ];

      wayland.windowManager.hyprland.settings.workspace = let
        opacity = "0.82";
        cwd = "${config.home.homeDirectory}/.dotfiles";
        scratch_term_cmd =
          "foot --app-id scratch --override colors.alpha=${opacity} --working-directory ${cwd}";
      in [
        "special:scratch, on-created-empty:${scratch_term_cmd}"
        "special:music, on-created-empty:jellyfin-desktop"
      ];
    };
}

