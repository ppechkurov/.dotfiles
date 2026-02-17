{
  flake.modules.homeManager.gtk = { pkgs, ... }: {
    gtk.enable = true;

    gtk.theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
}

