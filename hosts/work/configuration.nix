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
    stable = with pkgs;
      let
        aws-rds-forward = pkgs.writeScriptBin "aws-rds-forward"
          (builtins.readFile ./../../modules/nixos/common/scripts/connect.sh);
      in [
        aws-rds-forward
        gnumake
        zip
        mattermost-desktop
        vial
        jellyfin-media-player
        cachix
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    unstable = with pkgs-unstable; [ ghostty hyprland-per-window-layout ];
  in stable ++ unstable;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.nix-ld.enable = true;
  programs.sniffnet.enable = true;

  programs.obs-studio = { enable = true; };

  # programs.niri.enable = true;
  # programs.niri.package = pkgs-unstable.niri;

  services.openssh.enable = true;

  home-manager = {
    users.${config.username} = import ./home.nix;
    extraSpecialArgs = { inherit inputs pkgs-unstable globals; };
  };
}
