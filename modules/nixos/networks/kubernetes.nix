{ lib, config, ... }:
with lib; {
  options = {
    local.kube.networks.enable =
      mkEnableOption "kubernetes network setup for vms";
  };

  config = mkIf config.local.kube.networks.enable {
    # networking.useDHCP = true;
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
  };
}
