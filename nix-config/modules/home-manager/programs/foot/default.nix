{ ... }: {
  config = {
    programs.foot = {
      enable = true;
      server.enable = false;
      settings = {
        main = {
          font = "JetBrainsMono Nerd Font:size=16";
          selection-target = "both";
        };
        mouse = { hide-when-typing = "yes"; };
        cursor = { blink = "yes"; };
        key-bindings = {
          scrollback-up-half-page = "Control+k";
          scrollback-down-half-page = "Control+j";
          show-urls-launch = "Control+Shift+u";
          unicode-input = "none";
          # search-start = "Control+slash";
        };
        search-bindings = {
          find-prev = "Control+n";
          find-next = "Control+Shift+n";
        };
      };
    };
  };
}

