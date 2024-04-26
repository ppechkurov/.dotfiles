{ inputs, config, ... }: {
  imports = [ ../../modules/nixos/common ./hardware-configuration.nix ];

  # declare hostname
  config.networking.hostName = "work";

  config.monitor = { "Virtual-1" = { mode = "1920x1080@59.963Hz"; }; };

  config.home-manager = {
    users.${config.username} = import ./home.nix;
    extraSpecialArgs = { inherit inputs; };
  };
}
