{ pkgs-unstable, ... }: {
  config = {
    programs.gh = {
      enable = true;
      extensions = [ pkgs-unstable.gh-dash ];
      settings = {
        editor = "nvim";
        git_protocol = "ssh";
        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
      };
    };
  };
}

