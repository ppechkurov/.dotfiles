{
  flake.modules.nixos.docker = { lib, pkgs, ... }: {
    nixpkgs.overlays = [ (final: prev: { docker = prev.docker_29; }) ];

    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    environment.systemPackages = [ pkgs.docker-credential-helpers ];
  };
}
