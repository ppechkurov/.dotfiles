{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = [ pkgs.nil pkgs.shfmt ];
    vimAlias = true;
    withNodeJs = true;
  };
}
