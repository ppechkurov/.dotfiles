{ config, globals, lib, ... }:
let
  cfg = config.local.wireguard;
  hostname = config.networking.hostName;
  listenPort = cfg.server.port;
  peer = globals.wg.peers."${hostname}";
  privateKeyFilename = "wireguard-${hostname}-private-key";
  server = globals.wg.server;
in {
  config = lib.mkIf cfg.enable {
    age.secrets."${privateKeyFilename}".file = ./${privateKeyFilename}.age;

    networking.firewall.trustedInterfaces = [ "wg0" ];

    # or allow specific ports only with
    # networking.firewall.interfaces.wg0.allowedTCPPorts = [ 8080 ];

    networking.wg-quick.interfaces = {
      wg0 = {
        inherit listenPort;
        address = with peer; [ "${ipv4}/24" "${ipv6}/64" ];
        privateKeyFile = config.age.secrets."${privateKeyFilename}".path;

        peers = with server; [{
          inherit publicKey;
          endpoint = "${publicIpv4}:${toString listenPort}";
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          persistentKeepalive = 15;
        }];
      };
    };
  };
}
