aws-region() {
  local -A regions
  # shellcheck disable=SC2190
  regions=(
    au: ap-southeast-2
    jp: ap-northeast-1
    eu: eu-central-1
    us: us-east-2
  )

  local list current selected region

  list=$(
    # shellcheck disable=SC2296
    for key in ${(k)regions}; do
      printf "%-10s %s\n" "$key" "${regions[$key]}"
    done
  )

  current=${AWS_DEFAULT_REGION:-not set}

  selected=$(echo "$list" | fzf \
    --tmux=center,40%,25% \
    --prompt="Select AWS Region> " \
    --header="Current: $current" \
    --layout=reverse \
    --query="${1:-}" \
    --nth=1,2)

  if [[ -n $selected ]]; then
    region=$(echo "$selected" | awk '{print $NF}')
    export AWS_DEFAULT_REGION=$region
    export AWS_REGION=$region
    echo "Switched to: $region"
  fi
}
