{ config, ... }:
let cfg = config.services.forgejo;
in {
  security.acme = {
    acceptTerms = true;
    defaults.email = "petr.pechkurov@gmail.com";
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "vps-pp.duckdns.org" = {
        enableACME = true;
        forceSSL = true;
        serverName = "vps-pp.duckdns.org";
        locations."/" = {
          proxyPass =
            "http://localhost:${toString cfg.settings.server.HTTP_PORT}";
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
