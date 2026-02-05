{ self, ... }: {
  systems = [ "x86_64-linux" ];
  flake.nixosModules.common = { pkgs, ... }: {
    imports = [
      self.nixosModules.boot
      self.nixosModules.petrp
      self.nixosModules.nix
      #
    ];

    i18n.defaultLocale = "en_US.UTF-8";

    console = {
      keyMap = "dvorak";
      font = "Lat2-Terminus16";
    };

    services.openssh.settings.PasswordAuthentication = false;

    environment.systemPackages = with pkgs; [ curl git jq unzip vim ];
  };
}
