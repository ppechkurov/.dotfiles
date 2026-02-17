{
  flake.modules.homeManager.gtk = { pkgs, ... }: {
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.simp1e-cursors;
      name = "Simp1e-Gruvbox-Dark";
      size = 24;
    };
  };
}
