{ self, ... }: {
  flake.modules.homeManager.vicinae = { pkgs-unstable, ... }: {
    programs.vicinae = {
      enable = true;
      package = pkgs-unstable.vicinae;
      useLayerShell = true;
      systemd = {
        enable = true;
        autoStart = true;
      };
    };
  };
}
