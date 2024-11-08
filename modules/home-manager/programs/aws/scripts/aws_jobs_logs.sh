#!/usr/bin/env bash

set -o pipefail

job_id=$1
region=${2:-"us-east-2"}

if [[ -z "$region" || -z "$job_id" ]]; then
  echo "Usage: $0 <job_id> [<region>]"
  exit 1
fi

log_stream_name=$(
  aws batch describe-jobs \
    --region "$region" \
    --jobs "$job_id" |
    jq -r '.jobs[0].container.logStreamName'
)

aws logs tail \
  /aws/batch/job \
  --region "$region" \
  --log-stream-names "$log_stream_name" \
  --format short \
  --follow
