{ inputs, self, ... }: {
  systems = [ "x86_64-linux" ];
  flake.nixosModules.dendrodule = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.dig ];
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };

  flake.nixosModule.vim = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.vim ];
  };

  flake.nixosConfigurations.home = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.dendrodule
      self.nixosModules.vim
      ../hosts/home/hardware-configuration.nix
      #
    ];

    # networking.hostName = "home";
  };
}
