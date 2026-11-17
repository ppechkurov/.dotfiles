#!/usr/bin/env bash

set -eu
set -o pipefail

# Usage: sg-ingress-add.zsh [IPv4 CIDR] [TCP port] [description]
# AWS_PROFILE and AWS_REGION select the account and region.
for dependency in aws fzf cut; do
  command -v "$dependency" >/dev/null || {
    print -u2 "Missing command: $dependency"
    exit 1
  }
done

cidr=${1:-}
port=${2:-}
description=${3:-}

sg_id=$(
  aws ec2 describe-security-groups \
    --query 'SecurityGroups[].[GroupId,GroupName,VpcId,Description]' \
    --output text |
    fzf --delimiter=$'\t' --with-nth=2.. --prompt='Security group> ' |
    cut -f1
) || exit 0
[[ -n "$sg_id" ]] || exit 0

if [[ -z "$cidr" ]]; then
  read -r 'cidr?IPv4 CIDR [127.0.0.1/32]: '
  cidr=${cidr:-127.0.0.1/32}
fi

if [[ -z "$port" ]]; then
  read -r 'port?TCP port [5432]: '
  port=${port:-5432}
fi

if [[ ! "$port" =~ ^[0-9]{1,5}$ ]]; then
  printf '%s\n' 'Port must be between 1 and 65535' >&2
  exit 1
fi

if [[ -z "$description" ]]; then
  read -r -p 'Rule description: ' description
fi

[[ -n "$description" ]] || {
  print -u2 'Description must not be empty'
  exit 1
}

escaped_description=${description//\\/\\\\}
escaped_description=${escaped_description//\"/\\\"}

aws ec2 authorize-security-group-ingress \
  --group-id "$sg_id" \
  --ip-permissions \
  "IpProtocol=tcp,FromPort=$port,ToPort=$port,IpRanges=[{CidrIp=$cidr,Description=\"$escaped_description\"}]"
