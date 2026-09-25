{ self, ... }: {
  flake.modules.nixos.mini = { pkgs, ... }: {
    imports = with self.modules.nixos; [
      awgServer
    ];

    age.secrets.amneziawg-server-mini-private-key.file = ./amneziawg-server-mini-private-key.age;
  };
}
