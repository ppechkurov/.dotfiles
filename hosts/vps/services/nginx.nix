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
          locations."/" = let port = toString cfg.settings.server.HTTP_PORT;
          in {
            proxyPass = "http://work.wg:${port}";
            extraConfig = ''
              proxy_set_header Connection $http_connection;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
