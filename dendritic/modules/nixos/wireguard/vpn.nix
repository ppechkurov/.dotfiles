{ self, ... }: {
  flake.modules.nixos.vpn = { config, ... }:
    let
      hostname = config.networking.hostName;
      privateKeyFilename = "wireguard-${hostname}-private-key";
    in {
      age.secrets.${privateKeyFilename}.file = ./${privateKeyFilename}.age;
      networking.wg-quick.interfaces = self.lib.mkWgInterface "vpn" config;
    };
}
