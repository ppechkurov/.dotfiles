{ self, ... }: {
  flake.modules.nixos.work = { pkgs, ... }: {
    home-manager.users = let system = pkgs.stdenv.hostPlatform.system;
    in self.lib.mkHomeManagerUser system "petrp";
  };
}
