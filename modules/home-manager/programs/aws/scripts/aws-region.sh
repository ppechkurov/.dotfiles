aws-region() {
  local list current selected region

  list=$(printf "%-10s %s\n" \
    "au" "ap-southeast-2" \
    "jp" "ap-northeast-1" \
    "eu" "eu-central-1" \
    "us" "us-east-2")

  current="${AWS_DEFAULT_REGION:-not set}"

  selected=$(
    echo "$list" |
      fzf \
        --tmux \
        --prompt="AWS Region> " \
        --header="Current: $current" \
        --height=~40% \
        --layout=reverse \
        --query="${1:-}" \
        --nth=1,2
  )

  if [[ -n "$selected" ]]; then
    region=$(awk '{print $NF}' <<<"$selected")
    export AWS_REGION="$region"
    echo "Switched to: $region"
  fi
}
