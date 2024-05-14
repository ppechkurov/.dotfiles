{ inputs, ... }: {
  programs.yazi = {
    enable = true;
    package =
      (import inputs.nixpkgs-unstable { system = "x86_64-linux"; }).yazi;
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

