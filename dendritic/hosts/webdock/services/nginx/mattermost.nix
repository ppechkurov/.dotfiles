{ self, ... }: {
  flake.modules.nixos.webdock = { pkgs-unstable, pkgs, config, ... }:
    let upstream = "mattermost";
    in {
      services.nginx.upstreams = {
        ${upstream} = let port = toString config.services.mattermost.port;
        in {
          servers."127.0.0.1:${port}" = { };
          extraConfig = "keepalive 32;";
        };
      };

      # Details: [link](https://nixos.org/manual/nixos/stable/index.html#module-security-acme)
      services.nginx.virtualHosts.${upstream} = {
        enableACME = true;
        forceSSL = true;

        serverName = self.globals.dns.mattermost;

        # [Docs](https://docs.mattermost.com/deploy/server/setup-nginx-proxy.html)
        # Actually, it should work without this. But it required if you need webhooks.
        locations."~ /api/v[0-9]+/(users/)?websocket$" = {
          proxyPass = "http://${upstream}";
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
          proxyPass = "http://${upstream}";
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
    };
}
