#!/usr/bin/env zsh

set -eu
set pipefail

# AWS_PROFILE and AWS_REGION select the account and region.
for dependency in aws fzf column awk cut; do
  command -v "$dependency" >/dev/null || {
    print -u2 "Missing command: $dependency"
    exit 1
  }
done

sg_id=$(
  aws ec2 describe-security-groups \
    --query 'SecurityGroups[].[GroupId,GroupName,VpcId,Description]' \
    --output text |
    fzf --delimiter=$'\t' --with-nth=2.. --prompt='Security group> ' |
    cut -f1
) || exit 0
[[ -n "$sg_id" ]] || exit 0

rule_id=$(
  {
    printf 'Rule ID\tProtocol\tFrom\tTo\tIPv4\tIPv6\tSource SG\tDescription\n'
    aws ec2 describe-security-group-rules \
      --filters "Name=group-id,Values=$sg_id" \
      --query 'SecurityGroupRules[?IsEgress==`false`].[SecurityGroupRuleId,IpProtocol,FromPort,ToPort,CidrIpv4,CidrIpv6,ReferencedGroupInfo.GroupId,Description]' \
      --output text
  } |
    column -t -s $'\t' |
    fzf --header-lines=1 --prompt='Remove ingress rule> ' |
    awk '{print $1}'
) || exit 0
[[ -n "$rule_id" ]] || exit 0

read -r "answer?Remove ingress rule $rule_id from $sg_id? [y/N]: "
[[ "$answer" == [yY] ]] || exit 0

aws ec2 revoke-security-group-ingress \
  --group-id "$sg_id" \
  --security-group-rule-ids "$rule_id"
