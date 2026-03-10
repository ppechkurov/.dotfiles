param=$(aws ssm describe-parameters --query "Parameters[*].{Name:Name}" --output text | fzf --prompt="Select SSM parameter: ")
if [ -n "$param" ]; then
  aws ssm get-parameter --name "$param" --with-decryption --query "Parameter.Value" --output text
fi
