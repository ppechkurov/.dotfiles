{ pkgs, config, ... }:

{
  config = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        lua
        lua-language-server
        nil
        nixfmt
        shfmt
        stylua
      ];
      vimAlias = true;
      withNodeJs = true;
    };

    xdg.configFile.nvim = let
      nvim_config_dir =
        "${config.home.homeDirectory}/.dotfiles/nix-config/modules/home-manager/programs/nvim";
    in {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink "${nvim_config_dir}/config";
      recursive = true;
    };
  };
}
