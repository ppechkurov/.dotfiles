{
  flake.modules.nixos.docker = { lib, pkgs, ... }: {
    virtualisation.containers.enable = true;
    virtualisation.containerd.enable = true;

    virtualisation.docker = {
      enable = lib.mkForce true;
      daemon.settings = {
        experimental = true;
        features = { buildkit = true; };
      };
      extraPackages = [ pkgs.docker-buildx ];
    };
  };
}
