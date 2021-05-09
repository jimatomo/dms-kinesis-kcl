#!/bin/bash

CHANGESET_OPTION="--no-execute-changeset"

if [ $# = 1 ] && [ $1 = "deploy" ]; then
  echo "deploy mode"
  CHANGESET_OPTION=""
fi

CFN_TEMPLATE=template/dms.yml
CFN_STACK_NAME=dms-kinesis-kcl-dms
DMS_TASK_JSON=`cat dms_settings/task_setting.json | jq -c`
DMS_MAPPING_JSON=`cat dms_settings/mapping.json | jq -c`
source parameter/parameter.txt
MASTER_USER_PASSWD=`aws ssm get-parameter --name ${MASTER_PASSWD} --with-decryption --query Parameter.Value --output text`

# テンプレートの実行
aws cloudformation deploy --stack-name ${CFN_STACK_NAME} --template-file ${CFN_TEMPLATE} ${CHANGESET_OPTION} \
  --parameter-overrides \
    PJPrefix=${PJ_PREFIX} \
    MasterUserPassword=${MASTER_USER_PASSWD} \
    DMSTaskSetting=${DMS_TASK_JSON} \
    DMSTableMapping=${DMS_MAPPING_JSON}
