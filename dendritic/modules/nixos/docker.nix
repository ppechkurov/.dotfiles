{
  flake.modules.nixos.docker = { lib, pkgs, ... }: {
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
