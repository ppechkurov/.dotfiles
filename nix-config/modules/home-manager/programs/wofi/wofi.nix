{ ... }:
{
  programs.wofi.enable = true;
  # https://github.com/prtce/wofi
  xdg.configFile."wofi".source = ./config;
}
