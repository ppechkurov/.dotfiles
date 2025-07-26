{ config, ... }: {
  age.secrets = let
    owner = "petrp";
    group = "users";
  in {
    mattermost-bot-webhook-url-file = {
      file = ../../services/restic/mattermost-webhook-url-file.age;
      inherit owner group;
    };
  };

  nixpkgs.overlays = [ (import ./notify.nix config) ];
}
