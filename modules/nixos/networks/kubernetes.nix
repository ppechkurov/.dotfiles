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

    systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";
    systemd.network = {
      enable = true;
      wait-online.enable = false;
      netdevs = {
        # Create the tap interface
        "20-tap2" = {
          enable = true;
          netdevConfig = {
            Kind = "tap";
            Name = "tap2";
          };
        };
        "20-tap3" = {
          enable = true;
          netdevConfig = {
            Kind = "tap";
            Name = "tap3";
          };
        };
        "20-bridge0" = {
          enable = true;
          netdevConfig = {
            Kind = "bridge";
            Name = "br0";
          };
        };
      };
      networks = {
        "30-enp5s0" = {
          matchConfig.Name = "enp5s0";
          linkConfig = { Unmanaged = "yes"; };
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
        "40-tap3" = {
          matchConfig.Name = "tap3";
          bridgeConfig = { };
          linkConfig = {
            ActivationPolicy = "always-up";
            RequiredForOnline = "no";
          };
          networkConfig = { Bridge = "br0"; };
        };
        "40-bridge0" = {
          matchConfig.Name = "br0";
          linkConfig = {
            ActivationPolicy = "always-up";
            RequiredForOnline = "no";
          };
          networkConfig = { Address = [ "192.168.100.5/24" ]; };
        };
      };
    };
  };
}
