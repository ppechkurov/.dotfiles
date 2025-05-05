{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
  ];

  boot.tmp.cleanOnBoot = true;
  boot.loader.timeout = 1;
  zramSwap.enable = true;
  networking.hostName = "vps";
  networking.domain = "local";
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/8sFXfWRrIE+n4TtvawXjd1QKIYadM2OR9PGOxHKrP petrp@home"
  ];
  system.stateVersion = "23.11";
}
