#!/bin/bash

CHANGESET_OPTION="--no-execute-changeset"

if [ $# = 1 ] && [ $1 = "deploy" ]; then
  echo "deploy mode"
  CHANGESET_OPTION=""
fi

CFN_TEMPLATE=template/iam.yml
CFN_STACK_NAME=dms-kinesis-kcl-IAM
source parameter/parameter.txt

# テンプレートの実行
aws cloudformation deploy --stack-name ${CFN_STACK_NAME} --template-file ${CFN_TEMPLATE} ${CHANGESET_OPTION} \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    PJPrefix=${PJ_PREFIX}


# cloud9 instanceにiam roleを紐付ける
if [ $# = 1 ] && [ $1 = "deploy" ]; then
  read -p "Enter Your VPC Stack name: " VPC_CFN_STACK_NAME
  echo
  VPC_ID=`aws cloudformation describe-stacks --stack-name ${VPC_CFN_STACK_NAME} --query Stacks[*].Outputs[*] | jq .[0] | jq 'map(select( .OutputKey == "VPC"))' | jq -r .[0].OutputValue`
  echo "Your VPC id: ${VPC_ID}"
  CLOUD9_EC2ID=`aws ec2 describe-instances --filter Name=vpc-id,Values=${VPC_ID} --query Reservations[*].Instances[*].InstanceId --output text`
  echo "Your Cloud9 instance id: ${CLOUD9_EC2ID}"
  Cloud9_EC2Role="${PJ_PREFIX}-kcl-exec-role"

  aws ec2 associate-iam-instance-profile --instance-id ${CLOUD9_EC2ID} --iam-instance-profile Name=${Cloud9_EC2Role}
fi
