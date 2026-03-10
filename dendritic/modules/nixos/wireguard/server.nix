{ self, ... }: {
  flake.modules.nixos.wgServer = { config, pkgs, lib, ... }:
    let
      defaultNetworkInterface = config.networking.defaultGateway6.interface;
      wg = self.globals.wg;
      hostName = config.networking.hostName;
      vpnPort = wg.servers.interfaces.${hostName}.listenPort;
      tunPort = wg.servers.interfaces.tun.listenPort;
    in {
      imports = with self.modules.nixos; [ wireguard ];
      # disable two way ping detection
      boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_all" = 1;

      environment.systemPackages = with pkgs; [ wireguard-tools ];

      # Enable NAT
      networking.nat = {
        enable = true;
        enableIPv6 = true;
        externalInterface = defaultNetworkInterface;
        internalInterfaces = [ "vpn" "tun" ];
      };

      networking.firewall.trustedInterfaces = [ "tun" ];
      networking.firewall.allowedUDPPorts = [ vpnPort tunPort ];

      age.secrets.wireguard-server-private-key.file =
        ./wireguard-server-private-key.age;

      networking.wg-quick.interfaces = {
        vpn = let privateIP = wg.servers.interfaces.${hostName}.ip;
        in {
          address = [ privateIP ];
          listenPort = vpnPort;
          privateKeyFile = config.age.secrets.wireguard-server-private-key.path;

          # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
          postUp = ''
            ${pkgs.iptables}/bin/iptables -A INPUT -p icmp --icmp-type echo-request -j DROP # disable two way ping detection
            ${pkgs.iptables}/bin/iptables -A FORWARD -i "vpn" -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${privateIP} -o ${defaultNetworkInterface} -j MASQUERADE
          '';

          # Undo the above
          preDown = ''
            ${pkgs.iptables}/bin/iptables -D INPUT -p icmp --icmp-type echo-request -j DROP # disable two way ping detection
            ${pkgs.iptables}/bin/iptables -D FORWARD -i "vpn" -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${privateIP} -o ${defaultNetworkInterface} -j MASQUERADE
          '';

          # Example [here](https://nixos.wiki/wiki/WireGuard#Setting_up_WireGuard_server.2Fclient_with_wg-quick_and_dnsmasq)
          peers = lib.mapAttrsToList (name: peer: {
            allowedIPs = with peer.interfaces.${hostName}; [ "${ip}/32" ];
            persistentKeepalive = 15;
            publicKey = peer.publicKey;
          }) wg.peers;
        };

        tun = let privateIP = wg.servers.interfaces.tun.ip;
        in {
          address = [ privateIP ];
          listenPort = tunPort;
          privateKeyFile = config.age.secrets.wireguard-server-private-key.path;

          postUp = ''
            ${pkgs.iptables}/bin/iptables -A FORWARD -i "tun" -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${privateIP} -o ${defaultNetworkInterface} -j MASQUERADE
          '';

          # Undo the above
          preDown = ''
            ${pkgs.iptables}/bin/iptables -D FORWARD -i "tun" -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${privateIP} -o ${defaultNetworkInterface} -j MASQUERADE
          '';

          # Example [here](https://nixos.wiki/wiki/WireGuard#Setting_up_WireGuard_server.2Fclient_with_wg-quick_and_dnsmasq)
          peers = lib.mapAttrsToList (name: peer: {
            allowedIPs = with peer.interfaces.tun; [ "${ip}/32" ];
            persistentKeepalive = 15;
            publicKey = peer.publicKey;
          }) wg.peers;
        };
      };
    };
}
