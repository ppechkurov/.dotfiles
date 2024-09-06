{ inputs, config, pkgs, pkgs-unstable, ... }: {
  imports = [ ../../modules/nixos/common ./hardware-configuration.nix ];

  # declare hostname
  networking.hostName = "work";

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = let
    stable = with pkgs; [ skypeforlinux gnumake zip ];
    unstable = with pkgs-unstable; [ jetbrains.writerside ];
  in stable ++ unstable;

  home-manager = {
    users.${config.username} = import ./home.nix;
    extraSpecialArgs = {
      inherit inputs;
      inherit pkgs-unstable;
    };
  };
}
