{ config, pkgs, ... }:
let
  cfg = config.networking;
  defaultInterface = cfg.defaultGateway6.interface;
  wgInterfaceName = "wg0";
  wgServerPrivateIpv4 = "10.0.100.1/24";
  wgServerPrivateIpv6 = "fdc9:281f:04d7:9ee9::1/64";
  wgServerPort = 51820;
in {
  environment.systemPackages = with pkgs; [ wireguard-tools ];

  # Enable NAT
  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = defaultInterface;
    internalInterfaces = [ wgInterfaceName ];
  };

  # Open ports in the firewall
  networking.firewall = { allowedUDPPorts = [ wgServerPort ]; };

  age.secrets.wireguard-private-key.file = ./wireguard-private-key.age;

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ wgServerPrivateIpv4 wgServerPrivateIpv6 ];
      listenPort = wgServerPort;
      privateKeyFile = config.age.secrets.wireguard-private-key.path;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      postUp = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i ${wgInterfaceName} -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${wgServerPrivateIpv4} -o ${defaultInterface} -j MASQUERADE
        ${pkgs.iptables}/bin/ip6tables -A FORWARD -i ${wgInterfaceName} -j ACCEPT
        ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s ${wgServerPrivateIpv6} -o ${defaultInterface} -j MASQUERADE
      '';

      # Undo the above
      preDown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i ${wgInterfaceName} -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${wgServerPrivateIpv4} -o ${defaultInterface} -j MASQUERADE
        ${pkgs.iptables}/bin/ip6tables -D FORWARD -i ${wgInterfaceName} -j ACCEPT
        ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s ${wgServerPrivateIpv6} -o ${defaultInterface} -j MASQUERADE
      '';

      peers = [
        # Home
        {
          publicKey = "I9LlpFOmXIuql4TLf/o3oGQ5GhS9ciX0oLsEjdUQiik=";
          allowedIPs = [ "10.0.100.2/32" "fdc9:281f:04d7:9ee9::2/128" ];
        }
      ];
    };
  };
}
