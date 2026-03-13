{ self, ... }:
let user = "petrp";
in {
  flake.modules.nixos.kirillp = { pkgs, pkgs-unstable, ... }: {
    home-manager.users.${user} = {
      imports = with self.modules.homeManager; [ cli dconf nvim xdg ];

      # provides pkgs-unstable param in hm modules
      _module.args = { inherit pkgs-unstable; };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      home.stateVersion = "24.05";
    };
  };
}
