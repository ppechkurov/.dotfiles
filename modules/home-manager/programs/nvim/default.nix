{ pkgs, pkgs-unstable, config, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = pkgs-unstable.neovim-unwrapped;
    extraPackages = with pkgs; [
      ansible-lint
      lua
      lua-language-server
      marksman
      nil
      nixfmt-classic
      nodePackages.bash-language-server
      nodePackages.sql-formatter
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      prettierd
      shfmt
      stylua
      yaml-language-server
    ];
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
  };

  xdg.configFile.nvim = let
    nvim_config_dir =
      "${config.home.homeDirectory}/.dotfiles/modules/home-manager/programs/nvim";
  in {
    enable = true;
    source = config.lib.file.mkOutOfStoreSymlink "${nvim_config_dir}/config";
    recursive = true;
  };

  # https://search.nixos.org/packages?channel=unstable&show=codeium&from=0&size=50&sort=relevance&type=packages&query=codeium
  xdg.dataFile.".codeium" = let
    commit = "f772d3d7b45d3f1aea82cee1fb50501c8869f1a2";
    # "$(which codeium_language_server)"
    exec = "/run/current-system/sw/bin/codeium_language_server";
  in {
    source = config.lib.file.mkOutOfStoreSymlink "${exec}";
    target = ".codeium/bin/${commit}/language_server_linux_x64";
    recursive = true;
  };
}
