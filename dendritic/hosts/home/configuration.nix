{ self, config, ... }:
let user = "petrp";
in {
  flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" "home";
  flake.homeConfigurations = self.lib.mkHomeManager "x86_64-linux" user;

  flake.modules.nixos.home-configuration = { pkgs, ... }: {
    imports = with self.modules.nixos; [
      home-manager

      fonts
      greetd
      sound

      hyprland
    ];

    home-manager.users.${user} = {
      imports = [ self.modules.homeManager.${user} ];
    };

    environment.systemPackages = with pkgs; [ foot ];
  };

  flake.modules.homeManager.${user} = {
    imports = with self.modules.homeManager; [
      keyboard
      hyprland
      hyprpaper
      nvim
      zsh
      { home.stateVersion = "23.11"; }
    ];
  };

  # flake.nixosConfigurations.home = inputs.nixpkgs.lib.nixosSystem {
  #   modules = with self.modules.nixos; [
  #     self.nixosModules.homeHardware
  #
  #     common
  #     home-manager
  #
  #     self.nixosModules.fonts
  #     self.nixosModules.greetd
  #     self.nixosModules.sound
  #
  #     self.nixosModules.hyprland
  #     self.nixosModules.hyprlandMonitor
  #   ];
  # };

  flake.nixosModules.hyprlandMonitor = { config, ... }: {
    home-manager.users.${config.username}.imports = let
      HP = "DP-4";
      samsung = "DVI-D-1";
      TV = "HDMI-A-4";
    in [{
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
