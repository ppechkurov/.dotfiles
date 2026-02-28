{ self, ... }: {
  flake.modules.nixos.wgPeer = { config, lib, ... }:
    let
      hostName = config.networking.hostName;
      privateKeyFilename = "wireguard-${hostName}-private-key";
      wgInterfaces = [ "tun" "bluevps" "webdock" ];
      mkWgInterface = name:
        (self.lib.mkWgInterface name hostName
          config.age.secrets.${privateKeyFilename}.path);
    in {
      imports = with self.modules.nixos; [ wireguard ];

      age.secrets.${privateKeyFilename}.file = ./${privateKeyFilename}.age;

      networking.firewall.trustedInterfaces = [ "tun" ];

      networking.wg-quick.interfaces =
        lib.mergeAttrsList (builtins.map mkWgInterface wgInterfaces);
    };
}
