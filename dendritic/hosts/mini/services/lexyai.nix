{ self, ... }: {
  flake.modules.nixos.mini = { config, ... }: {
    services.lexyai.host = self.globals.wg.peers.mini.interfaces.tun.ip;
  };
}
