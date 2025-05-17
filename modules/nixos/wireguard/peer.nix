{ config, globals, lib, ... }:
let
  cfg = config.local.wireguard;
  hostname = config.networking.hostName;
  listenPort = cfg.server.port;
  peer = globals.wg.peers."${hostname}";
  privateKeyFilename = "wireguard-${hostname}-private-key";
  server = globals.wg.server;

  # Function to generate WireGuard interface configuration
  mkInterface = { address, allowedIPs, endpoint }: {
    inherit address;
    privateKeyFile = config.age.secrets."${privateKeyFilename}".path;
    peers = with server; [{
      inherit publicKey allowedIPs endpoint;
      persistentKeepalive = 15;
    }];
  };
in {
  config = lib.mkIf cfg.enable {
    age.secrets."${privateKeyFilename}".file = ./${privateKeyFilename}.age;

    networking.firewall.trustedInterfaces = [ "tun" ];
    networking.firewall.interfaces.vpn.allowedTCPPorts = [ 8080 ];

    networking.wg-quick.interfaces = let serverPublicIp = cfg.server.publicIpv4;
    in {
      vpn = mkInterface {
        address = (with peer.networks; [ "${vpn.ipv4}/24" "${vpn.ipv6}/64" ]);
        allowedIPs = [ "0.0.0.0/0" "::/0" ];
        endpoint = "${serverPublicIp}:${toString listenPort}";
      };

      tun = mkInterface {
        address = (with peer.networks; [ "${tun.ipv4}/24" "${tun.ipv6}/64" ]);
        allowedIPs = (with server.networks.tun; [ "${ipv4}/24" "${ipv6}/64" ]);
        endpoint = "${serverPublicIp}:${toString (listenPort + 1)}";
      };
    };
  };
}
