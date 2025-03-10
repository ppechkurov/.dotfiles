{ lib, config, ... }:
with lib;
let maxVMs = 4;
in {
  options = {
    kube.networks-2.enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.kube.networks-2.enable {
    networking.useNetworkd = true;
    networking.nat = {
      enable = true;
      internalIPs = [ "10.0.0.0/24" ];
      # Change this to the interface with upstream Internet access
      externalInterface = "enp5s0";
    };

    # systemd.network.networks = builtins.listToAttrs (map (index: {
    #   name = "30-vm${toString index}";
    #   value = {
    #     matchConfig.Name = "vm${toString index}";
    #     # Host's addresses
    #     address = [ "10.0.0.0/32" "fec0::/128" ];
    #     # Setup routes to the VM
    #     routes = [
    #       { Destination = "10.0.0.${toString index}/32"; }
    #       { Destination = "fec0::${lib.toHexString index}/128"; }
    #     ];
    #     # Enable routing
    #     networkConfig = { IPForward = true; };
    #   };
    # }) (lib.genList (i: i + 1) maxVMs));

    systemd.network.networks = {
      "30-vm1" = {
        matchConfig.Name = "vm1";
        address = [ "10.0.0.0/32" "fec0::/128" ];

        # routes = [
        #   { Destination = "10.0.0.1/32"; }
        #   { Destination = "fec0::${lib.toHexString 1}/128"; }
        # ];

        # Enable routing
        networkConfig = { IPForward = true; };
      };
    };
  };
}
