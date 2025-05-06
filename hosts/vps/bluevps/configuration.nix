{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.secret.nix # generated at runtime by nixos-infect
  ];

  local.wireguard.server.enable = true;
}
