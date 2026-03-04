{ self, ... }: {
  flake.modules.nixos.home = { pkgs, ... }: {
    home-manager.users = let system = pkgs.stdenv.hostPlatform.system;
    in self.lib.mkHomeManagerUser system "petrp";
  };
}
