#!/bin/bash

CHANGESET_OPTION="--no-execute-changeset"

if [ $# = 1 ] && [ $1 = "deploy" ]; then
  echo "deploy mode"
  CHANGESET_OPTION=""
fi

CFN_TEMPLATE=template/aurora.yml
CFN_STACK_NAME=dms-kinesis-kcl-aurora
source parameter/parameter.txt

# テンプレートの実行
aws cloudformation deploy --stack-name ${CFN_STACK_NAME} --template-file ${CFN_TEMPLATE} ${CHANGESET_OPTION} \
  --parameter-overrides \
    PJPrefix=${PJ_PREFIX} \
    MasterUserPasswordSSMParam=${MASTER_PASSWD}