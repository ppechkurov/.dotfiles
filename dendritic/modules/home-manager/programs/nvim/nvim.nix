{
  flake.modules.homeManager.nvim = { pkgs-unstable, pkgs, config, ... }: {
    programs.neovim.enable = true;

    programs.neovim = {
      package = pkgs.neovim-unwrapped;

      defaultEditor = true;
      sideloadInitLua = true; # required to manage config via symlink
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = false;

      extraPackages = with pkgs; [
        bash-language-server
        gh # needed for octo.nvim
        kdlfmt
        lua
        lua-language-server
        marksman
        nil
        nixfmt
        prettierd
        ripgrep
        shfmt
        sql-formatter
        stylua
        tree-sitter
        typescript
        typescript-language-server
        vscode-langservers-extracted
        yaml-language-server
      ];
    };

    xdg.configFile.nvim = let
      nvim_config_dir =
        "${config.home.homeDirectory}/.dotfiles/dendritic/modules/home-manager/programs/nvim";
    in {
      enable = true;
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${nvim_config_dir}/config";
    };

    programs.git.settings = {
      merge.tool = "codediff";
      mergetool.codediff.cmd = ''
        nvim "$MERGED" -c "CodeDiff merge "$MERGED"
      '';

      diff.tool = "codediff";
      difftool.codediff.cmd = ''
        nvim "$LOCAL" "$REMOTE" +"CodeDiff file $LOCAL $REMOTE"
      '';
    };
  };
}
