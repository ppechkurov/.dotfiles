{ self, ... }:
let host = "mini";
in {
  flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" host;

  flake.modules.nixos."${host}" = { lib, pkgs, pkgs-unstable, ... }: {
    imports = with self.modules.nixos; [
      home-manager # The actual HM module
      cli
      wgPeer
    ];

    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "Europe/Minsk";
  };
}
