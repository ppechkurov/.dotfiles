{
  flake.modules.nixos.docker = { lib, pkgs, ... }: {
    virtualisation.docker.enable = lib.mkDefault true;
    environment.systemPackages = [ pkgs.docker-credential-helpers ];
  };
}
