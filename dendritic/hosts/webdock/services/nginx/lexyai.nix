{ self, ... }: {
  flake.modules.nixos.webdock = { config, ... }:
    let
      cfg = config.local;
      miniIp = cfg.nginx.forwardIP;
      port = "8000";
    in {
      services.nginx.virtualHosts.lexyai = {
        enableACME = true;
        forceSSL = true;

        serverName = self.globals.dns.files;

        locations."/" = {
          proxyPass = "http://${miniIp}:${port}";
          extraConfig = ''
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
