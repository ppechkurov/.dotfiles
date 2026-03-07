{
  flake.modules.homeManager.hyprland = let
    music = "class:org.jellyfin.JellyfinDesktop";
    pavucontrol = "class:pavucontrol";
  in { lib, osConfig, ... }: {
    wayland.windowManager.hyprland.settings.windowrule = [
      "move 0 0,title:^(flameshot)"
      "suppressevent fullscreen,title:^(flameshot)"

      # polkit prompt
      "pin,class:gay.vaskel.soteria"
    ];

    wayland.windowManager.hyprland.settings.windowrulev2 =
      let steam = osConfig.programs.steam;
      in [
        "float, ${music}"
        "size 80% 80%, ${music}"
        "center, floating:1, ${music}"

        "float, ${pavucontrol}"
        "size 50% 50%, ${pavucontrol}"
        "center, floating:1, ${pavucontrol}"
        "stayfocused, ${pavucontrol}"
        "float, title:^(flameshot)"

        "workspace 1, class:default"
        "workspace 2 silent, class:firefox"
        (lib.mkIf steam.enable "workspace 3 silent, class:steam")
        "workspace 4 silent, class:org.telegram.desktop"
        "workspace 5 silent, class:Slack"
        "workspace 6 silent, class:ssh"

        "workspace 10 silent, class:signal"
      ];
  };
}
