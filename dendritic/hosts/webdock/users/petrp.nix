{ self, ... }:
let user = "petrp";
in {
  flake.modules.nixos.webdock = { pkgs, pkgs-unstable, lib, ... }: {
    nix.settings.trusted-users = [ user ];

    users.users.${user}.extraGroups = [ "nginx" ];

    home-manager.users.${user} = {
      imports = with self.modules.homeManager; [
        atuin
        cli
        # mini # mini it's a hostname in this case
      ];

      # provides pkgs-unstable param in hm modules
      _module.args = { inherit pkgs-unstable; };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      home.stateVersion = "24.05";
    };
  };
}
