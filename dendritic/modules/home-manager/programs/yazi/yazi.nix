{
  flake.modules.homeManager.yazi = { pkgs-unstable, ... }: {
    programs.yazi.enable = true;

    programs.yazi = {
      package = pkgs-unstable.yazi;
      enableZshIntegration = true;
      shellWrapperName = "yy";
      settings = {
        mgr = {
          linemode = "mtime";
          show_hidden = true;
          sort_by = "natural";
          sort_dir_first = true;
          sort_reverse = false;
          show_symlink = true;
        };
      };
    };
  };
}
