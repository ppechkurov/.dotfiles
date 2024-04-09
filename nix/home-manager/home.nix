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

  users = {
    petrp = {
      isNormalUser = true;
      hashedPassword = "$6$ATTQnc91//TUYRQH$.He6RJvD/FNRCbNXrht/hO7399SqwZzXdSnpWzVNKVTRfiJyheUBE9nnGfN7M06c0tKKEU91.Ldb4dtTYJ9fn/";
      extraGroups = ["wheel"];
      packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
    };
  };

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


  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
