{ lib, globals, ... }: {
  options.local.wireguard = with lib; {
    enable = mkEnableOption "wireguard";

    server = {
      enable = mkEnableOption "wireguard server";

      vpnInterface = mkOption {
        type = types.str;
        description = "Wireguard server network interface";
        default = "wg0";
      };

      internalInterface = mkOption {
        type = types.str;
        description = "Wireguard server network interface";
        default = "int0";
      };

      port = mkOption {
        type = types.number;
        description = "Wireguard server port";
        default = 51820;
      };

      publicIpv4 = mkOption {
        type = types.str;
        description = "Wireguard server public ip v4";
        default = globals.wg.server.publicIpv4;
      };

      privateIpv4 = mkOption {
        type = types.str;
        description = "Wireguard server private v4 subnet";
        default = "10.0.100.1/24";
      };

      privateIpv6 = mkOption {
        type = types.str;
        description = "Wireguard server private v6 subnet";
        default = "fdc9:281f:04d7:9ee9::1/64";
      };
    };
  };
}
