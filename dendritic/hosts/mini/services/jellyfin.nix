{
  flake.modules.nixos.mini = {
    services.jellyfin.enable = true;
    services.jellyfin.openFirewall = true;
  };
}
