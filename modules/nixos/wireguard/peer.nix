{ config, globals, lib, ... }:
let
  cfg = config.local.wireguard;
  hostname = config.networking.hostName;
  listenPort = cfg.server.port;
  peer = globals.wg.peers."${hostname}";
  privateKeyFilename = "wireguard-${hostname}-private-key";
  servers = globals.wg.servers;

  # Function to generate WireGuard interface configuration
  mkInterface = { address, allowedIPs, endpoint }: {
    inherit address;
    privateKeyFile = config.age.secrets."${privateKeyFilename}".path;
    peers = with servers; [{
      inherit publicKey allowedIPs endpoint;
      persistentKeepalive = 15;
    }];
  };
in {
  config = lib.mkIf cfg.enable {
    age.secrets."${privateKeyFilename}".file = ./${privateKeyFilename}.age;

    networking.firewall.trustedInterfaces = [ "tun" ];
    networking.firewall.interfaces.vpn.allowedTCPPorts = [ 8080 ];

    networking.wg-quick.interfaces = let
      vpnPublicIp = servers.vpn.publicIpv4;
      tunPublicIp = servers.tun.publicIpv4;
    in {
      vpn = mkInterface {
        address = (with peer.networks; [ "${vpn.ipv4}/24" "${vpn.ipv6}/64" ]);
        allowedIPs = [ "0.0.0.0/0" "::/0" ];
        endpoint = "${vpnPublicIp}:${toString listenPort}";
      };

      tun = mkInterface {
        address = (with peer.networks; [ "${tun.ipv4}/24" "${tun.ipv6}/64" ]);
        allowedIPs = (with servers.networks.tun; [ "${ipv4}/24" "${ipv6}/64" ]);
        endpoint = "${tunPublicIp}:${toString (listenPort + 1)}";
      };
    };
  };
}
