{ pkgs, config, ... }:

{
  config = {

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        lua
        lua-language-server
        nodePackages.bash-language-server
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
  };
}
