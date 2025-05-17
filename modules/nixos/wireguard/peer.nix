{ config, globals, lib, ... }:
let
  cfg = config.local.wireguard;
  hostname = config.networking.hostName;
  listenPort = cfg.server.port;
  peer = globals.wg.peers."${hostname}";
  privateKeyFilename = "wireguard-${hostname}-private-key";
  server = globals.wg.server;

  # Function to generate WireGuard interface configuration
  mkInterface = allowedIPs: address: listenPort: {
    inherit address;
    privateKeyFile = config.age.secrets."${privateKeyFilename}".path;
    peers = with server;
      let publicIpv4 = cfg.server.publicIpv4;
      in [{
        inherit publicKey allowedIPs;
        endpoint = "${publicIpv4}:${toString listenPort}";
        persistentKeepalive = 15;
      }];
  };
in {
  config = lib.mkIf cfg.enable {
    age.secrets."${privateKeyFilename}".file = ./${privateKeyFilename}.age;

    networking.firewall.trustedInterfaces = [ "tun" ];
    networking.firewall.interfaces.vpn.allowedTCPPorts = [ 8080 ];

    networking.wg-quick.interfaces = {
      vpn = mkInterface [ "0.0.0.0/0" "::/0" ]
        (with peer.networks; [ "${vpn.ipv4}/24" "${vpn.ipv6}" ]) listenPort;

      tun =
        mkInterface (with server.networks.tun; [ "${ipv4}/24" "${ipv6}/64" ])
        (with peer.networks; [ "${tun.ipv4}/24" "${tun.ipv6}" ])
        (listenPort + 1);
    };
  };
}
