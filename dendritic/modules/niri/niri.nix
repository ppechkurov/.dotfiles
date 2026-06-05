{ self, ... }: {
  flake.modules.nixos.niri = { pkgs, pkgs-unstable, ... }: {
    imports = with self.modules.nixos; [ oniri ];

    programs.niri.enable = true;
    programs.niri.package = pkgs-unstable.niri;
    environment.systemPackages = with pkgs; [ xwayland-satellite ];
  };

  flake.modules.homeManager.niri = { config, pkgs, ... }: {
    xdg.configFile."niri/config.kdl" = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/dendritic/modules/niri/config/config.kdl";
    };

    xdg.portal.enable = true;
    xdg.portal = {
      config.common.default = [ "gnome" ];
      extraPortals =
        [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome ];
      xdgOpenUsePortal = true;
    };
  };
}
