{
  flake.modules.nixos.webdock = { pkgs-unstable, pkgs, config, ... }:
    let
      cfg = config.local;
      miniPcIp = cfg.nginx.forwardIP;
    in {
      networking.firewall.allowedTCPPorts = [ cfg.forgejo.sshPort ];

      services.nginx = {
        # forgejo ssh on 2222. Maybe read on how to access it on 22?
        streamConfig = ''
          server {
            listen ${toString cfg.forgejo.sshPort};
            proxy_pass ${miniPcIp}:22;
          }
        '';

        upstreams = {
          forgejo = let
            port = toString config.services.forgejo.settings.server.HTTP_PORT;
          in {
            servers."${miniPcIp}:${port}" = { };
            extraConfig = "keepalive 32;";
          };
        };

        # Details: [link](https://nixos.org/manual/nixos/stable/index.html#module-security-acme)
        virtualHosts = {
          git = {
            enableACME = true;
            forceSSL = true;

            serverName = cfg.forgejo.dns;

            locations."/" = {
              proxyPass = "http://forgejo";
              extraConfig = ''
                proxy_set_header Connection $http_connection;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;

                client_max_body_size 512M;
              '';
            };
          };
        };
      };
    };
}
