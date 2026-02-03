{ inputs, self, ... }: {
  systems = [ "x86_64-linux" ];
  flake.nixosConfigurations.home = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.myMachineModule
      self.nixosModules.myFirstModule
      self.nixosModules.mySecondModule
      self.nixosModules.hardwareModule
      # ../hosts/home/hardware-configuration.nix
    ];
  };

  flake.nixosModules.myMachineModule = { pkgs, ... }: {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
