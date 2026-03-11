{
  flake.modules.nixos.boot = { pkgs, ... }: {
    boot.loader.timeout = 1;
    boot.tmp.cleanOnBoot = true;
  };
}
