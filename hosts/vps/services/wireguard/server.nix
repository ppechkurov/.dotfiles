{ lib, config, pkgs, globals, ... }:
let
  cfg = config.local.wireguard.server;
  defaultNetworkInterface = config.networking.defaultGateway6.interface;
in {
  options.local.wireguard.server = with lib; {
    enable = mkEnableOption "wireguard server";

    interface = mkOption {
      type = types.str;
      description = "Wireguard server network interface";
      default = "wg0";
    };

    port = mkOption {
      type = types.number;
      description = "Wireguard server port";
      default = 51820;
    };

    privateIpv4 = mkOption {
      type = types.str;
      description = "Wireguard server private v4 IP address";
      default = "10.0.100.1/24";
    };

    privateIpv6 = mkOption {
      type = types.str;
      description = "Wireguard server private v6 IP address";
      default = "fdc9:281f:04d7:9ee9::1/64";
    };
  };

  config = with cfg;
    lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ wireguard-tools ];

      # Enable NAT
      networking.nat = {
        enable = true;
        enableIPv6 = true;
        externalInterface = defaultNetworkInterface;
        internalInterfaces = [ interface ];
      };

      networking.firewall.allowedUDPPorts = [ port ];
      # INFO: This should allow access to port 8000 only from 10.0.100.2
      networking.firewall.extraCommands = ''
        ${pkgs.iptables}/bin/iptables -A INPUT -i ${interface} -s 10.0.100.2 -p tcp --dport 8000 -j ACCEPT
      '';
      networking.firewall.extraStopCommands = ''
        ${pkgs.iptables}/bin/iptables -D INPUT -i ${interface} -s 10.0.100.2 -p tcp --dport 8000 -j ACCEPT || true
      '';

      age.secrets.wireguard-server-private-key.file =
        ./wireguard-server-private-key.age;

      networking.wg-quick.interfaces = {
        "${interface}" = {
          address = [ privateIpv4 privateIpv6 ];
          listenPort = port;
          privateKeyFile = config.age.secrets.wireguard-server-private-key.path;

          # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
          postUp = ''
            ${pkgs.iptables}/bin/iptables -A FORWARD -i ${interface} -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${privateIpv4} -o ${defaultNetworkInterface} -j MASQUERADE
            ${pkgs.iptables}/bin/ip6tables -A FORWARD -i ${interface} -j ACCEPT
            ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s ${privateIpv6} -o ${defaultNetworkInterface} -j MASQUERADE
          '';

          # Undo the above
          preDown = ''
            ${pkgs.iptables}/bin/iptables -D FORWARD -i ${interface} -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${privateIpv4} -o ${defaultNetworkInterface} -j MASQUERADE
            ${pkgs.iptables}/bin/ip6tables -D FORWARD -i ${interface} -j ACCEPT
            ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s ${privateIpv6} -o ${defaultNetworkInterface} -j MASQUERADE
          '';

          # peers = [
          #   # Home
          #   {
          #     publicKey = "I9LlpFOmXIuql4TLf/o3oGQ5GhS9ciX0oLsEjdUQiik=";
          #     allowedIPs = [ "10.0.100.2/32" "fdc9:281f:04d7:9ee9::2/128" ];
          #   }
          #
          #   # Work
          #   {
          #     publicKey = "bBZ3r9G2gkcq/L8oNQTarJMUDB4Zuh0ut9qP4LsAzH4=";
          #     allowedIPs = [ "10.0.100.3/32" "fdc9:281f:04d7:9ee9::3/128" ];
          #   }
          #
          #   # Mobile
          #   {
          #     publicKey = "d5OWm1T2ZNE+irH8Q3qxMgjYmBbsYqM2mxCpBK1RoSU=";
          #     allowedIPs = [ "10.0.100.4/32" "fdc9:281f:04d7:9ee9::4/128" ];
          #   }
          # ];

          # Filter out the server and convert the remaining hosts to the desired peer format
          peers = lib.mapAttrsToList (name: peer: {
            publicKey = peer.publicKey;
            allowedIPs = [ "${peer.ipv4}/32" "${peer.ipv6}/128" ];
          }) globals.wg.peers;
        };
      };
    };
}
