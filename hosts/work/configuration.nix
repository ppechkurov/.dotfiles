{ inputs, config, pkgs, pkgs-unstable, ... }: {
  imports = [
    ../../modules/nixos/common
    ../../modules/nixos/wireguard
    ./hardware-configuration.nix
  ];

  # declare hostname
  networking.hostName = "work";

  local.wireguard.enable = true;
  networking.wg-quick.interfaces.vpn.autostart = false;

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = let
    stable = with pkgs; [ gnumake zip teams-for-linux ];
    unstable = with pkgs-unstable; [ ghostty ];
  in stable ++ unstable;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.nix-ld.enable = true;

  services.openssh.enable = true;

  home-manager = {
    users.${config.username} = import ./home.nix;
    extraSpecialArgs = {
      inherit inputs;
      inherit pkgs-unstable;
    };
  };
}
