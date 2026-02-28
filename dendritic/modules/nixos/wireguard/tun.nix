{ self, ... }: {
  flake.modules.nixos.tun = { config, ... }:
    let
      hostName = config.networking.hostName;
      privateKeyFilename = "wireguard-${hostName}-private-key";
    in {
      age.secrets.${privateKeyFilename}.file = ./${privateKeyFilename}.age;
      networking.firewall.trustedInterfaces = [ "tun" ];
      networking.wg-quick.interfaces = self.lib.mkWgInterface "tun" config;
    };
}
