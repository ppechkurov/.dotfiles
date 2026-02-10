{ inputs, self, ... }: {
  flake.homeConfigurations.petrp =
    inputs.home-manager.lib.homeManagerConfiguration { };

  flake.nixosConfigurations.home = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.modules.nixos; [
      self.nixosModules.homeHardware

      common
      home-manager

      self.nixosModules.fonts
      self.nixosModules.greetd
      self.nixosModules.sound

      self.nixosModules.hyprland
      self.nixosModules.hyprlandMonitor
    ];
  };

  flake.nixosModules.hyprlandMonitor = { config, ... }: {
    home-manager.users.${config.username}.imports = let
      HP = "DP-4";
      samsung = "DVI-D-1";
      TV = "HDMI-A-4";
    in [{
      wayland.windowManager.hyprland.settings.input = {
        kb_layout = "us,ru";
        kb_variant = "dvorak,";
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
    }];
  };
}
