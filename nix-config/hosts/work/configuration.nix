{ inputs, config, ... }: {
  imports = [ ../../modules/nixos/common ./hardware-configuration.nix ];

  # declare hostname
  networking.hostName = "work";

  monitor = { "Virtual-1" = { mode = "1920x1080@59.963Hz"; }; };

  programs.nm-applet.enable = true;

  home-manager = {
    users.${config.username} = import ./home.nix;
    extraSpecialArgs = { inherit inputs; };
  };
}
