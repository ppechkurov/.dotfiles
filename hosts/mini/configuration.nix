{ inputs, lib, config, pkgs, pkgs-unstable, ... }: {
  imports = [ ../../modules/nixos/wireguard ./hardware-configuration.nix ];

  # declare hostname
  networking.hostName = "home";
  local.wireguard.enable = true;
  # services.syncthing.enable = true;
  # services.gatus.enable = true;
  services.soft-serve.enable = true;

  services.openssh.enable = true;

  environment.systemPackages = [ ];

  time.timeZone = lib.mkForce "Europe/Minsk";

  home-manager = {
    users.${config.username} = import ./home.nix;
    extraSpecialArgs = {
      inherit inputs;
      inherit pkgs-unstable;
    };
  };
}
