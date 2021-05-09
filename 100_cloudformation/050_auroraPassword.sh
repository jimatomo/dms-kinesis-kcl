#!/bin/bash -e

read -sp "Enter YourAurora superuser Password: " AURORA_PASSWORD
source parameter/parameter.txt

aws ssm put-parameter \
    --name ${MASTER_PASSWD} \
    --type "SecureString" \
    --value ${AURORA_PASSWORD}
