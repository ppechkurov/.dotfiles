{ inputs, ... }:
let
  homeManagerConfig = { lib, ... }: {
    home-manager = {
      verbose = true;
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "backup";
      backupCommand = "rm";
      overwriteBackup = true;
    };
  };
in {
  flake.modules.nixos.home-manager = { hmInput ? inputs.home-manager, ... }: {
    imports = [ hmInput.nixosModules.home-manager homeManagerConfig ];
  };
}
