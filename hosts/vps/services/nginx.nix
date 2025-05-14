{ config, lib, ... }:
let cfg = config.services.forgejo;
in {
  options = { };
  config = lib.mkIf true {
    security.acme = {
      acceptTerms = true;
      defaults.email = "petr.pechkurov@gmail.com";
    };

    services.nginx = {
      enable = true;
      virtualHosts = {
        "git-pp.duckdns.org" = {
          enableACME = true;
          forceSSL = true;
          serverName = "git-pp.duckdns.org";
          locations."/" = {
            # proxyPass =
            #   "http://localhost:${toString cfg.settings.server.HTTP_PORT}";
            proxyPass = "http://work.wg:3000";
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
