{ lib, config, ... }: {
  config = lib.mkIf config.services.syncthing.enable {
    services.syncthing.settings = {
      options = { relaysEnabled = false; };
      folders = {
        "/home/sync" = {
          id = "syncme";
          # devices = [ "bigbox" ];
        };
      };
    };
  };
}
