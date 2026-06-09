{ self, ... }: {
  flake.modules.nixos.mini = { config, ... }: {
    services.lexyai.host = self.globals.wg.peers.mini.interfaces.tun.ip;

    systemd.services.lexyai = {
      after = [ "wg-quick-tun.service" ];
      requires = [ "wg-quick-tun.service" ];
    };
  };
}
