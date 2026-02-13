{
  flake.modules.homeManager.keyboard = {
    xdg.configFile.xkb = {
      enable = true;
      source = ./xkb;
      recursive = true;
    };
  };
}
