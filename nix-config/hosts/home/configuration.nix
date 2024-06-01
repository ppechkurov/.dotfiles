{ inputs, config, pkgs, ... }: {
  imports = [ ../../modules/nixos/common ./hardware-configuration.nix ];

  # declare hostname
  networking.hostName = "home";

  monitor = {
    "Virtual-1" = { mode = "1680x1050@59.954Hz"; };
    # "*" = {
    #   bg =
    #     "/home/${config.username}/.config/sway/hackerman-wallpapers.jpg fill";
    # };
  };

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ canon-cups-ufr2 gutenprint ];

  home-manager = {
    users.${config.username} = import ./home.nix;
    extraSpecialArgs = { inherit inputs; };
  };
}
