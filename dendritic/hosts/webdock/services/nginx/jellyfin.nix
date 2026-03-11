{ self, ... }: {
  flake.modules.nixos.webdock = { pkgs-unstable, pkgs, config, ... }:
    let
      cfg = config.local;
      miniPcIp = cfg.nginx.forwardIP;
      port = "8096";
    in {
      # Details: [link](https://nixos.org/manual/nixos/stable/index.html#module-security-acme)
      services.nginx.virtualHosts.jellyfin = {
        enableACME = true;
        forceSSL = true;

        serverName = self.globals.dns.jellyfin;

        locations."/" = {
          proxyPass = "http://${miniPcIp}:${port}";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;

            # Disable buffering when the nginx proxy gets very resource heavy upon streaming
            proxy_buffering off;
          '';
        };

        # Proxy Jellyfin Websockets traffic
        locations."/socket" = {
          proxyPass = "http://${miniPcIp}:${port}";
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
          '';
        };
      };
    };
}

