{
  flake.modules.homeManager.nvim = { pkgs-unstable, pkgs, config, ... }: {
    programs.neovim.enable = true;

    programs.neovim = {
      package = pkgs.neovim-unwrapped;

      defaultEditor = true;
      vimAlias = true;
      withNodeJs = true;
      withPython3 = true;

      extraPackages = with pkgs; [
        gh # needed for octo.nvim
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
        ripgrep
        shfmt
        stylua
        typescript
        typescript-language-server
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
