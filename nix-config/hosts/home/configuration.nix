{ inputs, config, ... }: {
  imports = [ ../../modules/nixos/common ./hardware-configuration.nix ];

  # declare hostname
  networking.hostName = "home";

  monitor = {
    "Virtual-1" = { mode = "1680x1050@59.954Hz"; };
    "*" = { bg = "hackerman-wallpapers.jpg fill"; };
  };

  home-manager = {
    users.${config.username} = import ./home.nix;
    extraSpecialArgs = { inherit inputs; };
  };
}
