{ inputs, lib, config, pkgs, pkgs-unstable, ... }: {
  imports = [
    ../../modules/nixos/common
    ../../modules/nixos/nvidia
    ../../modules/nixos/wireguard
    ../../modules/nixos/networks/kubernetes.nix
    ../../modules/nixos/services/syncthing.nix
    ../../modules/nixos/services/gatus.nix
    ./hardware-configuration.nix
  ];

  # declare hostname
  networking.hostName = "home";
  local.wireguard.enable = true;
  services.syncthing.enable = true;
  services.gatus.enable = true;

  # Uncomment this if you want to play with the kube again.
  # specialisation.kuber = {
  #   inheritParentConfig = true;
  #   configuration = {
  #     system.nixos.tags = [ "kuber" ];
  #     local.kube.networks.enable = true;
  #   };
  # };

  monitor = {
    "Virtual-1" = { mode = "1680x1050@59.954Hz"; };
    "*" = { bg = "hackerman-wallpapers.jpg fill"; };
  };

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ canon-cups-ufr2 gutenprint ];

  services.openssh.enable = true;

  environment.systemPackages = with pkgs;
    let gostman = inputs.gostman.packages.${pkgs.system}.default;
    in [ steam-run protonup gostman ];

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  time.timeZone = lib.mkForce "Europe/Minsk";

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluez;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  hardware.enableAllFirmware = true;

  home-manager = {
    users.${config.username} = import ./home.nix;
    extraSpecialArgs = {
      inherit inputs;
      inherit pkgs-unstable;
    };
  };
}
