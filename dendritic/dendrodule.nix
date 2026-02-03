{ inputs, self, ... }: {
  flake.modules.dendrodule = { pkgs, ... }: {
    environment.systemPackages = [ self.packages.${pkgs.system}.dig ];
  };
}
