#!/usr/bin/env bash

set -euo pipefail

for required_command in aws fzf column nproc; do
  if ! command -v "$required_command" >/dev/null 2>&1; then
    echo "$required_command is required" >&2
    exit 1
  fi
done

ecs_clusters=$(aws ecs list-clusters --query 'clusterArns[]' --output text)

if [[ -z "$ecs_clusters" ]]; then
  echo "No ECS clusters found" >&2
  exit 1
fi

# AWS text output is tab-separated. Convert it to one cluster name per line
# before passing it to fzf. Exiting fzf with Escape exits the script cleanly.
ecs_cluster=$(
  printf '%s\n' "$ecs_clusters" |
    tr '\t' '\n' |
    sed 's#.*/##' |
    sort |
    fzf --prompt='ECS cluster> '
) || exit 0

ecs_services=$(aws ecs list-services \
  --cluster "$ecs_cluster" \
  --query 'serviceArns[]' \
  --output text)

if [[ -z "$ecs_services" ]]; then
  echo "No ECS services found in $ecs_cluster" >&2
  exit 1
fi

# mapfile reads each input line into a Bash array; -t removes newlines.
# < <(...) feeds the generated list into mapfile using process substitution.
mapfile -t ecs_service_arns < <(
  printf '%s\n' "$ecs_services" |
    tr '\t' '\n' |
    sort
)

# Parallel requests may finish in any order. Each worker writes to a numbered
# temporary file so the final output can still follow the sorted service list.
result_dir=$(mktemp -d)

cleanup() {
  for service_index in "${!ecs_service_arns[@]}"; do
    rm -f "$result_dir/$service_index"
  done

  rmdir "$result_dir"
}

trap cleanup EXIT

request_pids=()
cpu_cores=$(nproc)
max_parallel=$((cpu_cores / 2))
spinner_enabled=false
# shellcheck disable=SC1003
spinner_frames=('|' '/' '-' '\')
spinner_index=0

# Even a single-core machine should be allowed to run one worker.
if ((max_parallel < 1)); then
  max_parallel=1
fi

if [[ -t 2 ]]; then
  spinner_enabled=true
fi

show_spinner() {
  if [[ "$spinner_enabled" == true ]]; then
    printf '\r%s Fetching task definitions...' "${spinner_frames[$((spinner_index % 4))]}" >&2
    spinner_index=$((spinner_index + 1))
  fi
}

clear_spinner() {
  if [[ "$spinner_enabled" == true ]]; then
    printf '\r\033[K' >&2
  fi
}

# Show the first frame immediately, before any AWS requests are launched.
show_spinner

for service_index in "${!ecs_service_arns[@]}"; do
  ecs_service_arn="${ecs_service_arns[$service_index]}"

  # Wait for a slot before starting another background worker.
  while (($(jobs -pr | wc -l) >= max_parallel)); do
    show_spinner
    sleep 0.1
  done

  # Parentheses create a subshell; the trailing & runs it in the background.
  (
    service_details=$(aws ecs describe-services \
      --cluster "$ecs_cluster" \
      --services "$ecs_service_arn" \
      --query 'services[0].[serviceName,taskDefinition]' \
      --output text)

    # Split the AWS text response on its tab delimiter.
    IFS=$'\t' read -r service_name task_definition <<<"$service_details"

    images=$(aws ecs describe-task-definition \
      --task-definition "$task_definition" \
      --query 'taskDefinition.containerDefinitions[].image' \
      --output text)

    # Join multiple container images with commas and strip the ARN down to its
    # numeric revision (everything after the final colon).
    images=${images//$'\t'/,}
    task_revision="${task_definition##*:}"
    printf '%s\t%s\t%s\n' "$service_name" "$images" "$task_revision" >"$result_dir/$service_index"
  ) &

  # $! is the process ID of the background worker started immediately above.
  request_pids+=("$!")
done

# Keep animating while the final batch is still running.
while [[ -n "$(jobs -pr)" ]]; do
  show_spinner
  sleep 0.1
done

clear_spinner

request_failed=false

# wait returns each worker's exit status, allowing failures to be reported
# after every parallel request has finished.
for request_pid in "${request_pids[@]}"; do
  if ! wait "$request_pid"; then
    request_failed=true
  fi
done

if [[ "$request_failed" == true ]]; then
  echo "Failed to fetch one or more task definitions" >&2
  exit 1
fi

# column consumes the tab-separated rows and aligns them for terminal output.
{
  printf 'SERVICE\tIMAGE\tREVISION\n'

  for service_index in "${!ecs_service_arns[@]}"; do
    cat "$result_dir/$service_index"
  done
} | column -t -s $'\t'
