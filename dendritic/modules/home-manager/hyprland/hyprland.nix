{ inputs, self, ... }: {
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.nixosModules.hyprland = { pkgs, config, ... }: {
    programs.hyprland.enable = true;
    programs.hyprland.xwayland.enable = true;
    programs.hyprland.portalPackage = pkgs.xdg-desktop-portal-hyprland;

    home-manager.users.${config.username}.imports = [
      self.homeModules.hyprland
      self.homeModules.hyprpaper
      { home.stateVersion = config.system.stateVersion; }
    ];
  };

  flake.homeModules.hyprland = { ... }:
    let
      HP = "DP-4";
      samsung = "DVI-D-1";
      TV = "HDMI-A-4";
    in {
      wayland.windowManager.hyprland.systemd.variables = [ "--all" ];

      wayland.windowManager.hyprland.settings.input = {
        kb_layout = "us,ru,us";
        kb_variant = "dvorak,,basic";
      };

      wayland.windowManager.hyprland.settings.monitor = [
        "${HP}, preferred, 0x0, 1"
        "${samsung}, preferred, 1920x0, 1"
        "${TV}, preferred, 0x-1080, 1"
      ];

      wayland.windowManager.hyprland.settings.workspace = [
        # left
        "1, monitor:${HP}, default:true"
        "2, monitor:${HP}"
        "3, monitor:${HP}"
        "4, monitor:${HP}"
        "5, monitor:${HP}"

        # right
        "6, monitor:${samsung}, default:true"
        "7, monitor:${samsung}"
        "8, monitor:${samsung}"
        "9, monitor:${samsung}"
        "10, monitor:${samsung}"
      ];
    };
}
