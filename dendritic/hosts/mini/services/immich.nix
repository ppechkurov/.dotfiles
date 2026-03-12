{
  flake.modules.nixos.mini = { pkgs, ... }: {
    services.immich.enable = true;
    services.immich.openFirewall = true;
    services.immich.host = "0.0.0.0";

    environment.systemPackages = [ pkgs.immich ];

    # INFO: to change an admin password:
    # sudo -u immich \
    #   env DB_DATABASE_NAME=immich \
    #   DB_USERNAME=immich \
    #   DB_HOSTNAME=/run/postgresql/ \
    #   DB_SOCKET=/run/postgresql/.s.PGSQL.5432 \
    #   REDIS_SOCKET=/run/redis-immich/redis.sock \
    #   immich-admin reset-admin-password
  };
}
