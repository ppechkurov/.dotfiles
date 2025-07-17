{ inputs, config, pkgs, pkgs-unstable, globals, ... }: {
  imports = [
    ../../modules/nixos/common
    ../../modules/nixos/wireguard
    ../../modules/nixos/services/syncthing.nix
    ../../modules/nixos/services/forgejo.nix
    ./hardware-configuration.nix
  ];

  # declare hostname
  networking.hostName = "work";

  local.wireguard.enable = true;
  # local.forgejo.enable = true;
  # services.syncthing.enable = true;
  networking.wg-quick.interfaces.vpn.autostart = false;

  # needed for a custom keyboard
  services.udev.packages = with pkgs; [ qmk-udev-rules vial ];

  environment.systemPackages = let
    stable = with pkgs; [
      gnumake
      zip
      mattermost-desktop
      vial
      jellyfin-media-player
      cachix
    ];
    unstable = with pkgs-unstable; [ ghostty ];
  in stable ++ unstable;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.nix-ld.enable = true;
  programs.sniffnet.enable = true;

  services.openssh.enable = true;

  home-manager = {
    users.${config.username} = import ./home.nix;
    extraSpecialArgs = { inherit inputs pkgs-unstable globals; };
  };
}
