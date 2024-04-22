{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      lua
      lua-language-server
      nil
      nixfmt-classic
      shfmt
      stylua
    ];
    vimAlias = true;
    withNodeJs = true;
  };

  xdg.configFile.nvim = {
    enable = true;
    source = ./config;
    recursive = true;
  };
}
