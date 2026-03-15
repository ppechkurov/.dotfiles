{ inputs, self, lib, ... }: {
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

    i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

    console.keyMap = lib.mkDefault "dvorak";
    console.font = lib.mkDefault "Lat2-Terminus16";

    services.openssh.enable = true;
    services.openssh.settings.PasswordAuthentication = false;

    environment.systemPackages = with pkgs; [
      btop
      curl
      git
      jq
      ncdu
      systemd-manager-tui
      unzip
      vim
    ];

    system.stateVersion = "23.11";
  };
}
