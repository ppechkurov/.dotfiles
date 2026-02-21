{
  flake.modules.homeManager.yazi = { pkgs-unstable, config, ... }: {
    home.packages = [ pkgs-unstable.file ];

    xdg.configFile.yazi = let
      mkLink = config.lib.file.mkOutOfStoreSymlink;
      dir =
        "${config.home.homeDirectory}/.dotfiles/dendritic/modules/home-manager/programs/yazi";
    in {
      enable = true;
      source = mkLink "${dir}/config/theme.toml";
      target = "yazi/theme.toml";
    };
  };
}
