{ inputs, ... }:

{
  imports = [
    ../common
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  config = {
    # declare hostname
    networking.hostName = "work";
  };
}
