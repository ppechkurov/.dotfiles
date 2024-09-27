{ pkgs, pkgs-unstable, config, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = pkgs-unstable.neovim-unwrapped;
    # required for rest.nvim plugin. it uses luarocks and libs from there.
    extraLuaPackages = ps:
      with pkgs; [
        luajitPackages.luarocks-nix
        luajitPackages.lua-curl
        luajitPackages.xml2lua
        luajitPackages.mimetypes
        luajitPackages.fidget-nvim
        luajitPackages.nvim-nio
      ];
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
  # find the line with `let s:language_server_sha = 'lsp_sha'` in the /home/petrp/.local/share/nvim/lazy/codeium.vim/autoload/codeium/server.vim
  # and copy the sha from it to commit and update plugin
  xdg.dataFile.".codeium" = let
    commit = "071907d082576067b0c7a5f2f7659958865d751e";
    # "$(which codeium_language_server)"
    exec = "/run/current-system/sw/bin/codeium_language_server";
  in {
    source = config.lib.file.mkOutOfStoreSymlink "${exec}";
    target = ".codeium/bin/${commit}/language_server_linux_x64";
    recursive = true;
  };
}
