{ config, globals, ... }:
let cfg = config.services.forgejo;
in {
  imports = [
    ./hardware-configuration.nix
    ../services/mailserver.nix
    ./networking.secret.nix # generated at runtime by nixos-infect
  ];

  local.wireguard.server.enable = true;

  security.acme = {
    acceptTerms = true;
    defaults.email = "petr.pechkurov@gmail.com";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
