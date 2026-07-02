# @libnotify@ and @sound@ are Nix build-time substitutions (see development.nix).
queue_file="${CODEX_NOTIFY_FILE:-/tmp/codex-notify}"

if ! command -v @libnotify@ >/dev/null 2>&1; then
  echo "notify-send was not found" >&2
  exit 127
fi

play_sound() {
  [ "${CODEX_NOTIFY_SOUND:-1}" != "0" ] || return 0
  command -v pw-play >/dev/null 2>&1 || return 0
  [ -r @sound@ ] || return 0
  pw-play @sound@ >/dev/null 2>&1 &
}

touch "$queue_file"

tail -n 0 -F "$queue_file" | while IFS='	' read -r event_type message; do
  [ -n "$event_type$message" ] || continue
  urgency="${CODEX_NOTIFY_URGENCY:-normal}"

  printf '\033[32m%s\033[0m: %s\n' "$event_type" "$message"

  @libnotify@ \
    --app-name "Codex" \
    --urgency "$urgency" \
    -- "🔴 Codex needs attention" \
    "$event_type: $message"
  play_sound
done
