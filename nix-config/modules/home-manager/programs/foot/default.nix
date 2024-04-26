{ ... }: {
  config = {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = { font = "JetBrainsMono Nerd Font:size=16"; };
        mouse = { hide-when-typing = "yes"; };
        cursor = { blink = "yes"; };
      };
    };
  };
}

