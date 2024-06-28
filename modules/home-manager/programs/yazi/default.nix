{ pkgs-unstable, ... }: {
  programs.yazi = {
    enable = true;
    package = pkgs-unstable.yazi;
    enableZshIntegration = true;
    theme = import ./theme.nix;
    settings = {
      manager = {
        linemode = "mtime";
        show_hidden = true;
        sort_by = "natural";
        sort_dir_first = true;
        sort_reverse = false;
        show_symlink = true;
      };
    };
  };
}

