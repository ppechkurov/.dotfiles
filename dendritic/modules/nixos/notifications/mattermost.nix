{
  flake.modules.nixos.mattermost-send = { config, lib, pkgs, ... }: {
    age.secrets.mattermost-bot-webhook-url-file = {
      file = ./mattermost-webhook-url-file.age;
      owner = lib.mkDefault "petrp";
      group = lib.mkDefault "users";
    };

    nixpkgs.overlays = [
      (final: prev: {
        mattermost-send = pkgs.writeShellScriptBin "mattermost-send" ''
          if [ $# -eq 0 ]; then
            echo "Usage: mattermost-send <message> [<success | failure>]"
            exit 1
          fi

          TEXT="$1"
          STATUS="''${2:-success}"

          COLOR="#36A64F"
          if [ "$STATUS" != "success" ]; then
            COLOR="#FF0000"
          fi

          URL="$(cat ${config.age.secrets.mattermost-bot-webhook-url-file.path})"

          ${pkgs.curl}/bin/curl -X POST \
            -f \
            -H 'Content-Type: application/json' \
            -d '{
                  "channel": "backups",
                  "attachments": [
                    {
                      "text": "'"$TEXT"'",
                      "color": "'"$COLOR"'"
                    }
                  ]
                }' \
            "$URL"
        '';
      })
    ];
  };
}
