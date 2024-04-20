{ ... }:

{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = { font = "IosevkaTerm Nerd Font:size=16"; };
      mouse = { hide-when-typing = "yes"; };
      cursor = { blink = "yes"; };
    };
  };
}

