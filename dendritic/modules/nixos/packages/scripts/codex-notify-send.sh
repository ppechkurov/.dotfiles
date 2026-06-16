event="${1:-stop}"
project_name="${CODEX_NOTIFY_PROJECT:-$(basename "$PWD")}"
queue_file="${CODEX_NOTIFY_FILE:-/tmp/codex-notify}"
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || printf 'unknown')

case "$event" in
permission)
  event_type="permission"
  message="$project_name is waiting for approval on $branch"
  ;;
*)
  event_type="stop"
  message="$project_name turn finished on $branch"
  ;;
esac

printf '%s\t%s\n' "$event_type" "$message" >>"$queue_file"
