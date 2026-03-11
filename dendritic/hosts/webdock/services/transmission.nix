{
  flake.modules.nixos.webdock = { pkgs, lib, ... }: {
    services.transmission.enable = true;

    services.transmission = {
      package = pkgs.transmission_4;
      openFirewall = true;
      settings.incomplete-dir = "/mnt/sshfs/.incomplete";
      settings.download-dir = "/mnt/sshfs/Downloads";
      # extraFlags = [ "--log-level=debug" ];
    };

    # temp fix, because it wasn't starting with the default, which is "notify"
    systemd.services.transmission.serviceConfig.Type = lib.mkForce "simple";
  };
}
