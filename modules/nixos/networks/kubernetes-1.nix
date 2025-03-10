{ lib, config, ... }:
with lib; {
  options = {
    kube.networks-1.enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.kube.networks-1.enable {
    systemd.network.enable = true;
    systemd.network.wait-online.enable = false;

    systemd.network.networks."10-lan" = {
      matchConfig.Name = [ "eno1" "vm-*" ];
      networkConfig = { Bridge = "br0"; };
    };

    systemd.network.netdevs.br0 = {
      netdevConfig = {
        Name = "br0";
        Kind = "bridge";
      };
    };

    systemd.network.netdevs.tap1 = {
      enable = true;
      netdevConfig = {
        Name = "tap1";
        Kind = "tap";
      };
    };

    systemd.network.networks."10-lan-bridge" = {
      matchConfig.Name = "br0";
      networkConfig = {
        Address = [ "192.168.100.4/24" ];
        Gateway = "192.168.100.1";
        DNS = [ "192.168.100.1" ];
        IPv6AcceptRA = true;
      };
      linkConfig = {
        ActivationPolicy = "always-up";
        RequiredForOnline = "no";
      };
    };

    systemd.network.networks."20-tap1" = {
      matchConfig.Name = "tap1";
      bridgeConfig = { };
      networkConfig = { Bridge = "br0"; };
      linkConfig = {
        ActivationPolicy = "always-up";
        RequiredForOnline = "no";
      };
    };
  };
}
