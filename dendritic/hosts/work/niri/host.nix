{
  flake.modules.homeManager.work = { config, ... }: {
    xdg.configFile."niri/host.kdl" = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/dendritic/hosts/work/niri/host.kdl";
    };
  };
}
