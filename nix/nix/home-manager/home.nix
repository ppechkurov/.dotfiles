# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "petrp";
    homeDirectory = "/home/petrp";
  };

  xdg = {
    enable = true;
    configFile.nvim = {
      source = ../../nvim/.config/nvim;
    };
  };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "Petr Pechkurov";
      userEmail = "petr.pechkurov@gmail.com";
    };

    lazygit = {
      enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [];
        theme = "robbyrussell";
      };
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
