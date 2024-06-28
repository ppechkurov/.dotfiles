{ config, ... }: {
  wayland.windowManager.hyprland.settings.workspace = let
    opacity = "0.82";
    cwd = "${config.home.homeDirectory}/.dotfiles";
    scratch_term_cmd =
      "foot --app-id scratch --override colors.alpha=${opacity} --working-directory ${cwd}";
  in [
    "special:scratch, on-created-empty:${scratch_term_cmd}"
    "special:music, on-created-empty:music"
  ];
}
