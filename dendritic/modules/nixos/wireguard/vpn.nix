{ self, ... }: {
  flake.modules.nixos.vpn = { config, ... }:
    let
      hostName = config.networking.hostName;
      privateKeyFilename = "wireguard-${hostName}-private-key";
    in {
      age.secrets.${privateKeyFilename}.file = ./${privateKeyFilename}.age;
      networking.wg-quick.interfaces = self.lib.mkWgInterface "vpn" config;
    };
}
