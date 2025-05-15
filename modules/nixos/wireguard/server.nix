{ lib, config, pkgs, globals, ... }:
let
  cfg = config.local.wireguard.server;
  defaultNetworkInterface = config.networking.defaultGateway6.interface;
in {
  config = with cfg;
    lib.mkIf cfg.enable {
      # disable two way ping detection
      boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_all" = 1;
      environment.systemPackages = with pkgs; [ wireguard-tools ];

      # Enable NAT
      networking.nat = {
        enable = true;
        enableIPv6 = true;
        externalInterface = defaultNetworkInterface;
        internalInterfaces = [ vpnInterface internalInterface ];
      };

      networking.firewall.allowedUDPPorts = let internalPort = port + 1;
      in [ port internalPort ];

      age.secrets.wireguard-server-private-key.file =
        ./wireguard-server-private-key.age;

      networking.wg-quick.interfaces = {
        "${vpnInterface}" = {
          address = [ privateIpv4 privateIpv6 ];
          listenPort = port;
          privateKeyFile = config.age.secrets.wireguard-server-private-key.path;

          # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
          postUp = ''
            ${pkgs.iptables}/bin/iptables -A INPUT -p icmp --icmp-type echo-request -j DROP # disable two way ping detection
            ${pkgs.iptables}/bin/iptables -A FORWARD -i ${vpnInterface} -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${privateIpv4} -o ${defaultNetworkInterface} -j MASQUERADE
            ${pkgs.iptables}/bin/ip6tables -A INPUT -p icmp --icmp-type echo-request -j DROP # disable two way ping detection
            ${pkgs.iptables}/bin/ip6tables -A FORWARD -i ${vpnInterface} -j ACCEPT
            ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s ${privateIpv6} -o ${defaultNetworkInterface} -j MASQUERADE
          '';

          # Undo the above
          preDown = ''
            ${pkgs.iptables}/bin/iptables -D INPUT -p icmp --icmp-type echo-request -j DROP # disable two way ping detection
            ${pkgs.iptables}/bin/iptables -D FORWARD -i ${vpnInterface} -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${privateIpv4} -o ${defaultNetworkInterface} -j MASQUERADE
            ${pkgs.iptables}/bin/ip6tables -D INPUT -p icmp --icmp-type echo-request -j DROP # disable two way ping detection
            ${pkgs.iptables}/bin/ip6tables -D FORWARD -i ${vpnInterface} -j ACCEPT
            ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s ${privateIpv6} -o ${defaultNetworkInterface} -j MASQUERADE
          '';

          # Example [here](https://nixos.wiki/wiki/WireGuard#Setting_up_WireGuard_server.2Fclient_with_wg-quick_and_dnsmasq)
          peers = lib.mapAttrsToList (name: peer: {
            publicKey = peer.publicKey;
            allowedIPs = [ "${peer.ipv4vpn}/32" "${peer.ipv6vpn}/128" ];
          }) globals.wg.peers;
        };

        "${internalInterface}" = {
          address = [ globals.wg.server.ipv4Int globals.wg.server.ipv6Int ];
          listenPort = port + 1;
          privateKeyFile = config.age.secrets.wireguard-server-private-key.path;

          # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
          postUp = ''
            ${pkgs.iptables}/bin/iptables -A FORWARD -i ${internalInterface} -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${globals.wg.server.ipv4Int} -o ${defaultNetworkInterface} -j MASQUERADE
            ${pkgs.iptables}/bin/ip6tables -A INPUT -p icmp --icmp-type echo-request -j DROP # disable two way ping detection
            ${pkgs.iptables}/bin/ip6tables -A FORWARD -i ${internalInterface} -j ACCEPT
            ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s ${globals.wg.server.ipv6Int} -o ${defaultNetworkInterface} -j MASQUERADE
          '';

          # Undo the above
          preDown = ''
            ${pkgs.iptables}/bin/iptables -D FORWARD -i ${internalInterface} -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${globals.wg.server.ipv4Int} -o ${defaultNetworkInterface} -j MASQUERADE
            ${pkgs.iptables}/bin/ip6tables -D INPUT -p icmp --icmp-type echo-request -j DROP # disable two way ping detection
            ${pkgs.iptables}/bin/ip6tables -D FORWARD -i ${internalInterface} -j ACCEPT
            ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s ${globals.wg.server.ipv6Int} -o ${defaultNetworkInterface} -j MASQUERADE
          '';

          # Example [here](https://nixos.wiki/wiki/WireGuard#Setting_up_WireGuard_server.2Fclient_with_wg-quick_and_dnsmasq)
          peers = lib.mapAttrsToList (name: peer: {
            publicKey = peer.publicKey;
            allowedIPs = [ "${peer.ipv4Int}/32" "${peer.ipv6Int}/128" ];
          }) globals.wg.peers;
        };
      };
    };
}
