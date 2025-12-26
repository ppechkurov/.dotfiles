#!/usr/bin/env bash

set -eu

rds="$(aws rds describe-db-instances \
  --query 'DBInstances[*].[Endpoint.Address,Endpoint.Port]' \
  --output text | fzf)"

[ -z "$rds" ] && exit 1

host="$(echo "$rds" | awk '{print $1}')"
portNumber="$(echo "$rds" | awk '{print $2}')"

ec2="$(aws ec2 describe-instances \
  --query "Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,Tags[?Key==\`Name\`].Value|[0]]" \
  --output text |
  fzf |
  awk '{print $1}')"

[ -z "$ec2" ] && exit 1

echo forwading port "$portNumber" of "$host"

read -rp "Local port: " localport

aws ssm start-session \
  --target "$ec2" \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters '{
    "host":["'"$host"'"],
    "portNumber":["'"$portNumber"'"],
    "localPortNumber":["'"$localport"'"]
  }'
