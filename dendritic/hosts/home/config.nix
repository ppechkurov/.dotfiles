{ inputs, self, ... }: {
  flake.nixosConfigurations.home = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.homeHardware

      self.nixosModules.common
      self.nixosModules.data
      self.nixosModules.fonts
      self.nixosModules.greetd
      self.nixosModules.sound

      inputs.home-manager.nixosModules.home-manager

      self.nixosModules.hyprland
    ];
  };
}
