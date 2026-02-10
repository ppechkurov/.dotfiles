{ inputs, self, ... }: {
  systems = [ "x86_64-linux" ];
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    inputs.flake-parts.flakeModules.modules
    inputs.home-manager.flakeModules.home-manager
  ];
  flake.modules.nixos.common = { pkgs, ... }: {
    imports = [
      self.nixosModules.boot
      self.modules.nixos.petrp
      self.nixosModules.nix
      #
    ];

    i18n.defaultLocale = "en_US.UTF-8";

    console = {
      keyMap = "dvorak";
      font = "Lat2-Terminus16";
    };

    services.openssh.settings.PasswordAuthentication = false;

    environment.systemPackages = with pkgs; [ curl git jq unzip vim foot ];

    system.stateVersion = "23.11";
  };
}
