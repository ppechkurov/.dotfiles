{ inputs, config, ... }: {
  imports = [ ../../modules/nixos/common ./hardware-configuration.nix ];

  # declare hostname
  config.networking.hostName = "home";
  config.environment.systemPackages = [
    (import inputs.nixpkgs-unstable {
      system = "x86_64-linux";
      config = { allowUnfree = true; };
    }).codeium
  ];

  config.monitor = {
    "Virtual-1" = {
      mode = "1680x1050@59.954Hz";
      bg = "hackerman-wallpapers.jpg fill";
    };
  };

  config.home-manager = {
    users.${config.username} = import ./home.nix;
    extraSpecialArgs = { inherit inputs; };
  };
}
