{ self, inputs, ... }: {
  debug = true;
  flake.nixosConfigurations.home = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.common
      self.nixosModules.homeHardware
      self.nixosModules.data
      { system.stateVersion = "23.11"; }
    ];
  };
}
