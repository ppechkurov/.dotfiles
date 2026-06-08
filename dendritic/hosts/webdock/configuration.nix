{ self, ... }:
let
  host = "webdock";
  atuinHost = self.globals.wg.servers.interfaces.tun.ip;
in
{
  flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" host;

  flake.modules.nixos.${host} = { lib, pkgs, ... }: {
    imports = with self.modules.nixos; [
      fail2ban
      home-manager # The actual HM module
      wgServer
    ];

    services.atuin.enable = true;
    services.atuin.host = atuinHost;

    systemd.services.atuin = {
      after = [ "wg-quick-tun.service" ];
      requires = [ "wg-quick-tun.service" ];
    };

    # Signal network-online since we use static IP (no DHCP/networkd)
    systemd.services.wait-online = {
      after = [ "network.target" ];
      wantedBy = [ "network-online.target" ];
      serviceConfig.Type = "oneshot";
      script = "true";
    };

    boot.tmp.cleanOnBoot = true;
    boot.loader.timeout = 1;
    zramSwap.enable = true;

    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "Europe/Minsk";
  };
}
