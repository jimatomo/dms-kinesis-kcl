#!/bin/bash -e

CHANGESET_OPTION="--no-execute-changeset"

if [ $# = 1 ] && [ $1 = "deploy" ]; then
  echo "deploy mode"
  CHANGESET_OPTION=""
fi

CFN_TEMPLATE=template/security-group.yml
CFN_STACK_NAME=dms-kinesis-kcl-SG
source parameter/parameter.txt

# cloud9のセキュリティグループのIDを取得
#VPC_NAME=xxx
#VPC_ID=`aws ec2 describe-vpcs --filters Name=tag:Name,Values=${VPC_NAME} --query Vpcs[*].VpcId --output text`

# VPCのCloudformationのスタック名からフィルタをかけていく
read -p "Enter Your VPC Stack name: " VPC_CFN_STACK_NAME
echo
VPC_ID=`aws cloudformation describe-stacks --stack-name ${VPC_CFN_STACK_NAME} --query Stacks[*].Outputs[*] | jq .[0] | jq 'map(select( .OutputKey == "VPC"))' | jq -r .[0].OutputValue`
echo "Your VPC id: ${VPC_ID}"
CLOUD9_SGID=`aws ec2 describe-instances --filter Name=vpc-id,Values=${VPC_ID} --query Reservations[*].Instances[*].NetworkInterfaces[*].Groups[*].GroupId --output text`
echo "Your Cloud9 instance security group id: ${CLOUD9_SGID}"

# テンプレートの実行
aws cloudformation deploy --stack-name ${CFN_STACK_NAME} --template-file ${CFN_TEMPLATE} ${CHANGESET_OPTION} \
  --parameter-overrides \
    PJPrefix=${PJ_PREFIX} \
    cloud9SG=${CLOUD9_SGID}

# cloud9のSecurity GroupはAWS CLIで設定する
#if [ $# = 1 ] && [ $1 = "deploy" ]; then
#   AuroraSGID=`aws cloudformation describe-stacks --stack-name ${CFN_STACK_NAME} --query Stacks[*].Outputs[*] | jq .[0] | jq 'map(select( .OutputKey == "auroraSGID"))' | jq -r .[0].OutputValue`
#
#   aws ec2 authorize-security-group-ingress \
#     --group-id ${AuroraSGID} \
#     --source-group  ${CLOUD9_SGID} \
#     --protocol tcp \
#     --port 5432
# fi
