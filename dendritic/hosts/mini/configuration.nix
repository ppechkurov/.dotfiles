{ self, ... }:
let
  host = "mini";
in
{
  flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" host;

  flake.modules.nixos."${host}" = { lib, pkgs, ... }: {
    imports = with self.modules.nixos; [
      boot
      forgejo
      home-manager # The actual HM module
      lexyai
      wgPeer
    ];

    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "Europe/Minsk";
  };
}
