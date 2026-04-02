{
  flake.modules.nixos.mini = { pkgs-unstable, ... }: {
    services.jellyfin.enable = true;
    services.jellyfin.package = pkgs-unstable.jellyfin;
    services.jellyfin.openFirewall = true;
  };
}
