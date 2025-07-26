config: final: prev:
let data = builtins.toJSON { };
in {
  mattermost-send = prev.writeShellScriptBin "mattermost-send" ''
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

    ${prev.curl}/bin/curl -X POST \
      -f \
      -H 'Content-Type: application/json' \
      -d '{
            "attachments": [
              {
                "text": "'"$TEXT"'",
                "color": "'"$COLOR"'"
              }
            ]
          }' \
      "$URL"
  '';
}
