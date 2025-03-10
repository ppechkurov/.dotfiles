{ inputs, lib, config, pkgs, pkgs-unstable, ... }: {
  imports = [
    ../../modules/nixos/common
    ../../modules/nixos/nvidia
    ../../modules/nixos/networks/kubernetes.nix
    ./hardware-configuration.nix
  ];

  # declare hostname
  networking.firewall.enable = false;

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
    netdevs = {
      # Create the tap interface
      "20-tap1" = {
        enable = true;
        netdevConfig = {
          Kind = "tap";
          Name = "tap1";
        };
      };
      "20-tap2" = {
        enable = true;
        netdevConfig = {
          Kind = "tap";
          Name = "tap2";
        };
      };
    };
    networks = {
      "40-tap1" = {
        matchConfig.Name = "tap1";
        bridgeConfig = { };
        linkConfig = {
          ActivationPolicy = "always-up";
          RequiredForOnline = "no";
        };
        networkConfig = { Bridge = "br0"; };
      };
      "40-tap2" = {
        matchConfig.Name = "tap2";
        bridgeConfig = { };
        linkConfig = {
          ActivationPolicy = "always-up";
          RequiredForOnline = "no";
        };
        networkConfig = { Bridge = "br0"; };
      };
    };
  };

  # kube.networks.enable = true;
  # kube.networks-1.enable = true;
  # kube.networks-2.enable = true;

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
