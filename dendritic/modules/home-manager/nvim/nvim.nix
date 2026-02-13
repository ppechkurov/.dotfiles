{
  flake.modules.homeManager.nvim = { pkgs, config, ... }: {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      # package = pkgs-unstable.neovim-unwrapped;
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
        typescript
        typescript-language-server
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
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${nvim_config_dir}/config";
    };
  };
}
