{ inputs, ... }: {
  flake.modules.nixos.webdock = { pkgs, pkgs-unstable, ... }: {
    programs.nh.enable = true;

    environment.systemPackages = [ pkgs-unstable.mmctl ];
  };
}
