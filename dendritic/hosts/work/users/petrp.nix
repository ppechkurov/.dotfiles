{ self, ... }:
let user = "petrp";
in {
  flake.modules.nixos.work-configuration = { pkgs, pkgs-unstable, ... }: {
    services.greetd.settings.default_session.user = user;

    home-manager.users.${user} = {
      imports = [
        self.modules.homeManager.${user}
        self.modules.homeManager.work-overrides
      ];

      # access pkgs-unstable param in hm modules
      _module.args = { inherit pkgs-unstable; };
    };
  };
}
