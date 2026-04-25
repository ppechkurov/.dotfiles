{
  flake.modules.homeManager.nodejs = { pkgs-unstable, ... }: {
    home.packages = [ pkgs-unstable.nodejs ];

    home.sessionPath = [ "$HOME/.npm-global/bin" ];
  };
}

