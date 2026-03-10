{
  flake.modules.nixos.boot = { pkgs, ... }: {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.tmp.cleanOnBoot = true;
    boot.loader.timeout = 1;

    # Fix artifacts on boot: [link](https://github.com/NixOS/nixpkgs/issues/328972#issuecomment-3665270723)
    boot.loader.systemd-boot.consoleMode = "auto";
  };
}
