{ ... }: {
  config = {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = { font = "JetBrainsMono Nerd Font:size=16"; };
        mouse = { hide-when-typing = "yes"; };
        cursor = { blink = "yes"; };
        key-bindings = {
          scrollback-up-half-page = "Control+k";
          scrollback-down-half-page = "Control+j";
          show-urls-launch = "Control+u";
          search-start = "Control+slash";
        };
        search-bindings = {
          find-prev = "Control+n";
          find-next = "Control+Shift+n";
        };
      };
    };
  };
}

