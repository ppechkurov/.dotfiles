{ ... }: {
  flake.modules.nixos.webdock =
    { config, ... }:
    let
      miniPcIp = config.local.nginx.forwardIP;
      port = toString config.services.forgejo.settings.server.HTTP_PORT;
    in
    {
      users.users.nginx.extraGroups = [ config.users.groups.anubis.name ];

      services.anubis.instances.forgejo = {
        settings = {
          BIND = "/run/anubis/anubis-forgejo/anubis.sock";
          TARGET = "http://${miniPcIp}:${port}";
        };
      };
    };
}
