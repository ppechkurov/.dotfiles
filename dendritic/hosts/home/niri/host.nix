{
  flake.modules.homeManager.home = { config, ... }: {
    xdg.configFile."niri/host.kdl" = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/dendritic/hosts/home/niri/host.kdl";
    };
  };
}
