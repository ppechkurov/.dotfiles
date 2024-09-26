{ inputs, config, pkgs, pkgs-unstable, ... }:
let
  factorio = pkgs.writeScriptBin "factorio" # bash
    ''
      steam-run ~/factorio/bin/x64/factorio
    '';
in {
  imports = [
    ../../modules/nixos/common
    ../../modules/nixos/nvidia
    ./hardware-configuration.nix
  ];

  # declare hostname
  networking.hostName = "home";

  monitor = {
    "Virtual-1" = { mode = "1680x1050@59.954Hz"; };
    "*" = { bg = "hackerman-wallpapers.jpg fill"; };
  };

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ canon-cups-ufr2 gutenprint ];

  environment.systemPackages = with pkgs; [ steam-run factorio ];

  home-manager = {
    users.${config.username} = import ./home.nix;
    extraSpecialArgs = {
      inherit inputs;
      inherit pkgs-unstable;
    };
  };
}
