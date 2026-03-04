{
  flake.nixos.modules.mini = {
    services.jellyfin.enable = true;
    services.jellyfin.openFirewall = true;
  };
}
