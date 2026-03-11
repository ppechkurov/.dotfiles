{ self, ... }: {
  flake.modules.nixos.webdock = { config, ... }:
    let miniPcIp = self.globals.wg.peers.mini.interfaces.tun.ip;
    in {
      security.acme.acceptTerms = true;
      security.acme.defaults.email = self.globals.emails.gmail;

      services.nginx = let mmUpstream = "mattermost";
      in {
        enable = true;

        recommendedOptimisation = true;

        # forgejo ssh
        streamConfig = let forgejoSshPort = "2222";
        in ''
          server {
            listen ${forgejoSshPort};
            proxy_pass ${miniPcIp}:22;
          }
        '';

        upstreams = {
          ${mmUpstream} = {
            servers."127.0.0.1:8065" = { };
            extraConfig = "keepalive 32;";
          };
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

            serverName = self.globals.dns.forgejo;

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

          mattermost = {
            enableACME = true;
            forceSSL = true;

            serverName = self.globals.dns.mattermost;

            # [Docs](https://docs.mattermost.com/deploy/server/setup-nginx-proxy.html)
            # Actually, it should work without this. But it required if you need webhooks.
            locations."~ /api/v[0-9]+/(users/)?websocket$" = {
              proxyPass = "http://${mmUpstream}";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_set_header Connection "upgrade";
                client_max_body_size 50M;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_set_header X-Frame-Options SAMEORIGIN;
                proxy_buffers 256 16k;
                proxy_buffer_size 16k;
                client_body_timeout 60s;
                send_timeout 300s;
                lingering_timeout 5s;
                proxy_connect_timeout 90s;
                proxy_send_timeout 300s;
                proxy_read_timeout 90s;
              '';
            };

            locations."/" = {
              proxyPass = "http://${mmUpstream}";
              extraConfig = ''
                client_max_body_size 50M;
                proxy_set_header Connection "";
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_set_header X-Frame-Options SAMEORIGIN;
                proxy_buffers 256 16k;
                proxy_buffer_size 16k;
                proxy_read_timeout 600s;
              '';
            };
          };

          jellyfin = {
            enableACME = true;
            forceSSL = true;

            serverName = self.globals.dns.jellyfin;

            locations."/" = {
              proxyPass = "http://${miniPcIp}:8096";
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
              proxyPass = "http://${miniPcIp}:8096";
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
      };
    };
}
