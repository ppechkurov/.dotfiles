{
  flake.modules.nixos.boot = { pkgs, lib, ... }: {
    boot.loader.timeout = lib.mkDefault 1;
    boot.tmp.cleanOnBoot = true;
  };
}
