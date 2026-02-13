{ ... }:
let user = "petrp";
in {
  flake.modules.nixos.home-configuration = { pkgs, ... }: {
    services.greetd.settings.default_session.user = user;
  };
}
