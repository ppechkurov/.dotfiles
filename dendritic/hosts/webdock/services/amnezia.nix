{ self, ... }: {
  flake.modules.nixos.webdock = { pkgs, config, ... }: {
    imports = with self.modules.nixos; [
      awgServer
    ];

    age.secrets.amneziawg-server-webdock-private-key.file = ./amneziawg-server-webdock-private-key.age;

    services.awgServer =
      let
        privateKeyFile = config.age.secrets.amneziawg-server-webdock-private-key.path;
        externalInterface = config.networking.defaultGateway.interface;
      in
      {
        inherit externalInterface privateKeyFile;
        listenPort = 51822;
      };
  };
}
