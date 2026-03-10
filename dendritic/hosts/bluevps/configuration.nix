{ self, ... }:
let host = "bluevps";
in {
  flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" host;

  flake.modules.nixos."${host}" = { lib, pkgs, ... }: {
    imports = with self.modules.nixos; [ ];

    security.acme = {
      acceptTerms = true;
      defaults.email = "petr.pechkurov@gmail.com";
    };
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "Europe/Minsk";
  };
}
