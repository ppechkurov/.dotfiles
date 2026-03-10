{ self, ... }:
let host = "bluevps";
in {
  flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" host;

  flake.modules.nixos."${host}" = { lib, pkgs, ... }: {
    imports = with self.modules.nixos; [ mailserver wgServer ];

    boot.tmp.cleanOnBoot = true;
    boot.loader.timeout = 1;

    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "Europe/Minsk";
  };
}
