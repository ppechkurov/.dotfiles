{ self, ... }: {
  flake.modules.nixos.webdock = { lib, ... }: {
    options.local.forgejo.sshPort = lib.mkOption {
      type = lib.types.port;
      default = 2222;
      description = ''
        Defines an exposed port to connect to forgejo instance via SSH.
      '';
    };

    options.local.forgejo.dns = lib.mkOption {
      type = lib.types.str;
      default = self.globals.dns.forgejo;
      description = ''
        Public DNS of a forgejo instance.
      '';
    };

    options.local.nginx.forwardIP = lib.mkOption {
      type = lib.types.str;
      default = self.globals.wg.peers.mini.interfaces.tun.ip;
      description = ''
        IP address where to forward all requests.
      '';
    };
  };
}

