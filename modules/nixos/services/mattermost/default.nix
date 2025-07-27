{ config, lib, ... }: {
  age.secrets = let
    owner = "petrp";
    group = "users";
  in {
    mattermost-bot-webhook-url-file = {
      file = ../../services/restic/mattermost-webhook-url-file.age;
      owner = lib.mkDefault owner;
      group = lib.mkDefault group;
    };
  };

  nixpkgs.overlays = [ (import ./notify.nix config) ];
}
