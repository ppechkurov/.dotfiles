{ self, ... }: {
  flake.modules.nixos.niri = { pkgs, pkgs-unstable, ... }: {
    programs.niri.enable = true;
    programs.niri.package = pkgs-unstable.niri;
  };

  flake.modules.homeManager.niri = { pkgs, config, ... }: {
    xdg.configFile."niri/config.kdl" = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/dendritic/modules/niri/config/config.kdl";
    };
  };
}
