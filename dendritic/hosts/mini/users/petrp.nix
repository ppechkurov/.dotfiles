{ self, ... }:
let user = "petrp";
in {
  flake.modules.nixos.mini = { pkgs, pkgs-unstable, ... }: {
    home-manager.users.${user} = {
      imports = with self.modules.homeManager; [
        cli
        mini # mini it's a hostname in this case
        xdg
      ];

      # provides pkgs-unstable param in hm modules
      _module.args = { inherit pkgs-unstable; };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      home.stateVersion = "24.05";
    };
  };
}
