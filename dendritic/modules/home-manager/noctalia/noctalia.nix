{
  flake.modules.homeManager.noctalia = { config, ... }: {
    xdg.configFile.noctalia = let
      dir =
        "${config.home.homeDirectory}/.dotfiles/dendritic/modules/home-manager/noctalia";
    in {
      enable = true;
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${dir}/config";
    };
  };
}
