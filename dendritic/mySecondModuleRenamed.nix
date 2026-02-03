{ inputs, ... }: {
  flake.nixosModules.mySecondModule = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ git ];
  };
}
