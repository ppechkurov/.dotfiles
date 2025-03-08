{ lib, config, ... }:
with lib; {
  options = {
    kube.networks.enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.kube.networks.enable {
    networking.networkmanager = {
      enable = true;
      unmanaged = [ "tap0" "br0" ];
    };

    systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
    systemd.network = let
      createInterface = { name, kind ? "tap" }: {
        enable = true;
        netdevConfig = {
          Kind = kind;
          Name = name;
        };
      };
      createNetwork = name: {
        matchConfig.Name = name;
        bridgeConfig = { };
        linkConfig = {
          ActivationPolicy = "always-up";
          RequiredForOnline = "no";
        };
        networkConfig = { Bridge = "br0"; };
      };
    in {
      enable = true;
      wait-online.enable = false;
      netdevs = {
        "20-bridge0" = createInterface {
          name = "br0";
          kind = "bridge";
        };

        # jumpbox
        "20-tap1" = createInterface { name = "tap1"; };
        # server
        "20-tap2" = createInterface { name = "tap2"; };
        # node-1
        "20-tap3" = createInterface { name = "tap3"; };
        # node-2
        "20-tap4" = createInterface { name = "tap4"; };
      };

      networks = {
        "30-enp5s0" = {
          matchConfig.Name = "enp5s0";
          linkConfig = { Unmanaged = "yes"; };
        };

        "40-tap1" = createNetwork "tap1";
        "40-tap2" = createNetwork "tap2";
        "40-tap3" = createNetwork "tap3";
        "40-tap4" = createNetwork "tap4";

        "40-bridge0" = {
          matchConfig.Name = "br0";
          linkConfig = {
            ActivationPolicy = "always-up";
            RequiredForOnline = "no";
          };
          networkConfig = { Address = [ "192.168.100.3/24" ]; };
        };
      };
    };
  };
}
