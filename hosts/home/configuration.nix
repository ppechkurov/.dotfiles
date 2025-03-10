{ inputs, lib, config, pkgs, pkgs-unstable, ... }: {
  imports = [
    ../../modules/nixos/common
    ../../modules/nixos/nvidia
    ../../modules/nixos/networks/kubernetes.nix
    ./hardware-configuration.nix
  ];

  # declare hostname
  networking.hostName = "home";
  networking.useDHCP = false;
  networking.bridges = { br0 = { interfaces = [ "enp5s0" ]; }; };
  networking.interfaces.br0.ipv4.addresses = [{
    address = "192.168.100.3";
    prefixLength = 24;
  }];

  networking.defaultGateway = {
    address = "192.168.100.1";
    interface = "br0";
  };

  networking.nameservers = [ "192.168.100.1" "8.8.8.8" ];
  networking.useNetworkd = true;

  systemd.network = {
    enable = true;
    wait-online.enable = false;

    netdevs = builtins.listToAttrs (map (index: {
      name = "20-tap${toString index}";
      value = {
        enable = true;
        netdevConfig = {
          Kind = "tap";
          Name = "tap${toString index}";
        };
      };
    }) (lib.genList (i: i + 1) 4));

    networks = builtins.listToAttrs (map (index: {
      name = "30-tap${toString index}";
      value = {
        matchConfig.Name = "tap${toString index}";
        linkConfig = {
          ActivationPolicy = "always-up";
          RequiredForOnline = "no";
        };
        networkConfig = { Bridge = "br0"; };
      };
    }) (lib.genList (i: i + 1) 4));

  };

  monitor = {
    "Virtual-1" = { mode = "1680x1050@59.954Hz"; };
    "*" = { bg = "hackerman-wallpapers.jpg fill"; };
  };

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ canon-cups-ufr2 gutenprint ];

  environment.systemPackages = with pkgs; [ steam-run protonup ];

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
