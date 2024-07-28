{ inputs, config, pkgs, pkgs-unstable, ... }: {
  imports = [ ../../modules/nixos/common ./hardware-configuration.nix ];

  # declare hostname
  networking.hostName = "work";

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [ skypeforlinux gnumake zip ];

  home-manager = {
    users.${config.username} = import ./home.nix;
    extraSpecialArgs = {
      inherit inputs;
      inherit pkgs-unstable;
    };
  };
}
