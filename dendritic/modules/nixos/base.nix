{ inputs, self, ... }: {
  systems = [ "x86_64-linux" ];

  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.modules.nixos.base = { pkgs, ... }: {
    imports = with self.modules.nixos; [
      boot
      data
      nix
      petrp
      #
    ];

    i18n.defaultLocale = "en_US.UTF-8";

    console.keyMap = "dvorak";
    console.font = "Lat2-Terminus16";

    services.openssh.settings.PasswordAuthentication = false;

    environment.systemPackages = with pkgs; [ curl git jq unzip vim ];

    system.stateVersion = "23.11";
  };
}
