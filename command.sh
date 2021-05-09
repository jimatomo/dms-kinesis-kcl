#############################################
# 環境のデプロイ
#############################################

#--------------------------------------------
# VPCのデプロイ
#--------------------------------------------

# AWS CLIは設定済みであるとする

# gitからダウンロードするなりで準備する
ls -l

# Cloudformationテンプレート格納ディレクトリへ移動
cd 100_cloudformation

ls -l

# 実行権限がない場合には付与すること
# chmod +x *.sh
# ls -l


# changesetの確認
./010_vpc.sh

  Waiting for changeset to be created..
  Changeset created successfully. Run the following command to review changes:
  aws cloudformation describe-change-set --change-set-name arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620463212/850209fc-cd49-4eff-88da-b9df6bcd66c2

aws cloudformation describe-change-set --change-set-name arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620463212/850209fc-cd49-4eff-88da-b9df6bcd66c2
  {
      "Changes": [
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "InternetGatewayAttachment",
                  "ResourceType": "AWS::EC2::VPCGatewayAttachment",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "InternetGateway",
                  "ResourceType": "AWS::EC2::InternetGateway",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "PrivateRouteTableA",
                  "ResourceType": "AWS::EC2::RouteTable",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "PrivateRouteTableC",
                  "ResourceType": "AWS::EC2::RouteTable",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "PrivateSubnetARouteTableAssociation",
                  "ResourceType": "AWS::EC2::SubnetRouteTableAssociation",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "PrivateSubnetA",
                  "ResourceType": "AWS::EC2::Subnet",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "PrivateSubnetCRouteTableAssociation",
                  "ResourceType": "AWS::EC2::SubnetRouteTableAssociation",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "PrivateSubnetC",
                  "ResourceType": "AWS::EC2::Subnet",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "PublicRouteA",
                  "ResourceType": "AWS::EC2::Route",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "PublicRouteC",
                  "ResourceType": "AWS::EC2::Route",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "PublicRouteTableA",
                  "ResourceType": "AWS::EC2::RouteTable",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "PublicRouteTableC",
                  "ResourceType": "AWS::EC2::RouteTable",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "PublicSubnetARouteTableAssociation",
                  "ResourceType": "AWS::EC2::SubnetRouteTableAssociation",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "PublicSubnetA",
                  "ResourceType": "AWS::EC2::Subnet",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "PublicSubnetCRouteTableAssociation",
                  "ResourceType": "AWS::EC2::SubnetRouteTableAssociation",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "PublicSubnetC",
                  "ResourceType": "AWS::EC2::Subnet",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "VPC",
                  "ResourceType": "AWS::EC2::VPC",
                  "Scope": [],
                  "Details": []
              }
          }
      ],
      "ChangeSetName": "awscli-cloudformation-package-deploy-1620463212",
      "ChangeSetId": "arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620463212/850209fc-cd49-4eff-88da-b9df6bcd66c2",
      "StackId": "arn:aws:cloudformation:ap-northeast-1:147967438560:stack/dms-kinesis-kcl-VPC/0174d4d0-afd9-11eb-aa20-06c816ec4d35",
      "StackName": "dms-kinesis-kcl-VPC",
      "Description": "Created by AWS CLI at 2021-05-08T08:40:12.323294 UTC",
      "Parameters": [
          {
              "ParameterKey": "PublicSubnetCCIDR",
              "ParameterValue": "10.1.20.0/24"
          },
          {
              "ParameterKey": "PrivateSubnetACIDR",
              "ParameterValue": "10.1.110.0/24"
          },
          {
              "ParameterKey": "PrivateSubnetCCIDR",
              "ParameterValue": "10.1.120.0/24"
          },
          {
              "ParameterKey": "VPCCIDR",
              "ParameterValue": "10.1.0.0/16"
          },
          {
              "ParameterKey": "PJPrefix",
              "ParameterValue": "dms-kinesis-kcl"
          },
          {
              "ParameterKey": "PublicSubnetACIDR",
              "ParameterValue": "10.1.10.0/24"
          }
      ],
      "CreationTime": "2021-05-08T08:40:13.609Z",
      "ExecutionStatus": "AVAILABLE",
      "Status": "CREATE_COMPLETE",
      "StatusReason": null,
      "NotificationARNs": [],
      "RollbackConfiguration": {},
      "Capabilities": [],
      "Tags": null
  }


# デプロイ
./010_vpc.sh deploy


#--------------------------------------------
# Cloud9のデプロイ
#--------------------------------------------

# Changesetの確認
./020_cloud9.sh

  Waiting for changeset to be created..
  Changeset created successfully. Run the following command to review changes:
  aws cloudformation describe-change-set --change-set-name arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620463452/16cb84ef-5934-4b0e-b422-7872e58de9f1

aws cloudformation describe-change-set --change-set-name arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620463452/16cb84ef-5934-4b0e-b422-7872e58de9f1
  {
      "Changes": [
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "cloud9instancd",
                  "ResourceType": "AWS::Cloud9::EnvironmentEC2",
                  "Scope": [],
                  "Details": []
              }
          }
      ],
      "ChangeSetName": "awscli-cloudformation-package-deploy-1620463452",
      "ChangeSetId": "arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620463452/16cb84ef-5934-4b0e-b422-7872e58de9f1",
      "StackId": "arn:aws:cloudformation:ap-northeast-1:147967438560:stack/dms-kinesis-kcl-Cloud9/90e2d180-afd9-11eb-8448-0e2426fd2029",
      "StackName": "dms-kinesis-kcl-Cloud9",
      "Description": "Created by AWS CLI at 2021-05-08T08:44:12.918266 UTC",
      "Parameters": [
          {
              "ParameterKey": "PJPrefix",
              "ParameterValue": "dms-kinesis-kcl"
          }
      ],
      "CreationTime": "2021-05-08T08:44:13.956Z",
      "ExecutionStatus": "AVAILABLE",
      "Status": "CREATE_COMPLETE",
      "StatusReason": null,
      "NotificationARNs": [],
      "RollbackConfiguration": {},
      "Capabilities": [],
      "Tags": null
  }


# デプロイ
./020_cloud9.sh deploy



#--------------------------------------------
# Security Groupの作成
#--------------------------------------------

# Changesetの確認
./030_security-group.sh
  Enter Your VPC Stack name: dms-kinesis-kcl-VPC

  Your VPC id: vpc-064e407e3494eb71e
  Your Cloud9 instance security group id: sg-05bd1811512a6a759

  Waiting for changeset to be created..
  Changeset created successfully. Run the following command to review changes:
  aws cloudformation describe-change-set --change-set-name arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620463739/920a7174-57c2-42a4-80f2-42a335801b45

aws cloudformation describe-change-set --change-set-name arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620463739/920a7174-57c2-42a4-80f2-42a335801b45
  {
      "Changes": [
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "auroraSG",
                  "ResourceType": "AWS::EC2::SecurityGroup",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "dmsSG",
                  "ResourceType": "AWS::EC2::SecurityGroup",
                  "Scope": [],
                  "Details": []
              }
          }
      ],
      "ChangeSetName": "awscli-cloudformation-package-deploy-1620463739",
      "ChangeSetId": "arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620463739/920a7174-57c2-42a4-80f2-42a335801b45",
      "StackId": "arn:aws:cloudformation:ap-northeast-1:147967438560:stack/dms-kinesis-kcl-SG/3b9ae3b0-afda-11eb-a953-0ac722fb4b9b",
      "StackName": "dms-kinesis-kcl-SG",
      "Description": "Created by AWS CLI at 2021-05-08T08:48:59.356157 UTC",
      "Parameters": [
          {
              "ParameterKey": "cloud9SG",
              "ParameterValue": "sg-05bd1811512a6a759"
          },
          {
              "ParameterKey": "PJPrefix",
              "ParameterValue": "dms-kinesis-kcl"
          }
      ],
      "CreationTime": "2021-05-08T08:49:00.410Z",
      "ExecutionStatus": "AVAILABLE",
      "Status": "CREATE_COMPLETE",
      "StatusReason": null,
      "NotificationARNs": [],
      "RollbackConfiguration": {},
      "Capabilities": [],
      "Tags": null
  }


# Deployの実行
./030_security-group.sh deploy
  deploy mode
  Enter Your VPC Stack name: dms-kinesis-kcl-VPC

  Your VPC id: vpc-064e407e3494eb71e
  Your Cloud9 instance security group id: sg-05bd1811512a6a759

  Waiting for changeset to be created..
  Waiting for stack create/update to complete
  Successfully created/updated stack - dms-kinesis-kcl-SG



# Changesetの確認
./040_iam.sh

  Waiting for changeset to be created..
  Changeset created successfully. Run the following command to review changes:
  aws cloudformation describe-change-set --change-set-name arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620465885/a33bcb1b-a33d-4756-8412-1087a359e12d

aws cloudformation describe-change-set --change-set-name arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620465885/a33bcb1b-a33d-4756-8412-1087a359e12d
  {
      "Changes": [
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "KCLRole",
                  "ResourceType": "AWS::IAM::Role",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "RDSMonitoringRole",
                  "ResourceType": "AWS::IAM::Role",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "cloud9InstanceProfile",
                  "ResourceType": "AWS::IAM::InstanceProfile",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "dmsIamRole",
                  "ResourceType": "AWS::IAM::Role",
                  "Scope": [],
                  "Details": []
              }
          }
      ],
      "ChangeSetName": "awscli-cloudformation-package-deploy-1620465885",
      "ChangeSetId": "arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620465885/a33bcb1b-a33d-4756-8412-1087a359e12d",
      "StackId": "arn:aws:cloudformation:ap-northeast-1:147967438560:stack/dms-kinesis-kcl-IAM/3aa2d5d0-afdf-11eb-b261-069f71278669",
      "StackName": "dms-kinesis-kcl-IAM",
      "Description": "Created by AWS CLI at 2021-05-08T09:24:45.118595 UTC",
      "Parameters": [
          {
              "ParameterKey": "PJPrefix",
              "ParameterValue": "dms-kinesis-kcl"
          }
      ],
      "CreationTime": "2021-05-08T09:24:46.286Z",
      "ExecutionStatus": "AVAILABLE",
      "Status": "CREATE_COMPLETE",
      "StatusReason": null,
      "NotificationARNs": [],
      "RollbackConfiguration": {},
      "Capabilities": [
          "CAPABILITY_NAMED_IAM"
      ],
      "Tags": null
  }


# Deploy
./040_iam.sh deploy
  deploy mode

  Waiting for changeset to be created..
  Waiting for stack create/update to complete
  Successfully created/updated stack - dms-kinesis-kcl-IAM
  Enter Your VPC Stack name: dms-kinesis-kcl-VPC

  Your VPC id: vpc-064e407e3494eb71e
  Your Cloud9 instance id: i-0d68c212691517e4f
  {
      "IamInstanceProfileAssociation": {
          "AssociationId": "iip-assoc-0a3da11d681738e37",
          "InstanceId": "i-0d68c212691517e4f",
          "IamInstanceProfile": {
              "Arn": "arn:aws:iam::147967438560:instance-profile/dms-kinesis-kcl-kcl-exec-role",
              "Id": "AIPASE44L53QDC62XXEU6"
          },
          "State": "associated"
      }
  }


# Parameter Storeにパスワードを登録
./050_auroraPassword.sh
  Enter YourAurora superuser Password:
  {
      "Version": 1,
      "Tier": "Standard"
  }

# Changesetの確認
./051_aurora.sh

  Waiting for changeset to be created..
  Changeset created successfully. Run the following command to review changes:
  aws cloudformation describe-change-set --change-set-name arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620466359/8278834c-67a3-43aa-9164-7951fb9cebbb

aws cloudformation describe-change-set --change-set-name arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620466359/8278834c-67a3-43aa-9164-7951fb9cebbb
  {
      "Changes": [
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "DBSubnetGroup",
                  "ResourceType": "AWS::RDS::DBSubnetGroup",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "RDSCluster",
                  "ResourceType": "AWS::RDS::DBCluster",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "RDSDBClusterParameterGroup",
                  "ResourceType": "AWS::RDS::DBClusterParameterGroup",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "RDSDBInstance1",
                  "ResourceType": "AWS::RDS::DBInstance",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "RDSDBParameterGroup",
                  "ResourceType": "AWS::RDS::DBParameterGroup",
                  "Scope": [],
                  "Details": []
              }
          }
      ],
      "ChangeSetName": "awscli-cloudformation-package-deploy-1620466359",
      "ChangeSetId": "arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620466359/8278834c-67a3-43aa-9164-7951fb9cebbb",
      "StackId": "arn:aws:cloudformation:ap-northeast-1:147967438560:stack/dms-kinesis-kcl-aurora/55480350-afe0-11eb-b06f-0a385af6619b",
      "StackName": "dms-kinesis-kcl-aurora",
      "Description": "Created by AWS CLI at 2021-05-08T09:32:39.386119 UTC",
      "Parameters": [
          {
              "ParameterKey": "Username",
              "ParameterValue": "postgres"
          },
          {
              "ParameterKey": "PJPrefix",
              "ParameterValue": "dms-kinesis-kcl"
          },
          {
              "ParameterKey": "MasterUserPasswordSSMParam",
              "ParameterValue": "/dms-kinesis-kcl/aurora-admin-password"
          }
      ],
      "CreationTime": "2021-05-08T09:32:40.730Z",
      "ExecutionStatus": "AVAILABLE",
      "Status": "CREATE_COMPLETE",
      "StatusReason": null,
      "NotificationARNs": [],
      "RollbackConfiguration": {},
      "Capabilities": [],
      "Tags": null
  }

# Deploy
./051_aurora.sh deploy
  deploy mode

  Waiting for changeset to be created..
  Waiting for stack create/update to complete
  Successfully created/updated stack - dms-kinesis-kcl-aurora



# Kinesis
# Changeset の確認
./060_kinesis.sh

  Waiting for changeset to be created..
  Changeset created successfully. Run the following command to review changes:
  aws cloudformation describe-change-set --change-set-name arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620486435/f1758c1a-427c-492b-8798-de4d136c34b7

aws cloudformation describe-change-set --change-set-name arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620486435/f1758c1a-427c-492b-8798-de4d136c34b7
  {
      "Changes": [
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "kinesisStream",
                  "ResourceType": "AWS::Kinesis::Stream",
                  "Scope": [],
                  "Details": []
              }
          }
      ],
      "ChangeSetName": "awscli-cloudformation-package-deploy-1620486435",
      "ChangeSetId": "arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620486435/f1758c1a-427c-492b-8798-de4d136c34b7",
      "StackId": "arn:aws:cloudformation:ap-northeast-1:147967438560:stack/dms-kinesis-kcl-kinesis/cc08eda0-b00e-11eb-ad82-0a7e8630ea7f",
      "StackName": "dms-kinesis-kcl-kinesis",
      "Description": "Created by AWS CLI at 2021-05-08T15:07:15.614392 UTC",
      "Parameters": [
          {
              "ParameterKey": "PJPrefix",
              "ParameterValue": "dms-kinesis-kcl"
          }
      ],
      "CreationTime": "2021-05-08T15:07:16.874Z",
      "ExecutionStatus": "AVAILABLE",
      "Status": "CREATE_COMPLETE",
      "StatusReason": null,
      "NotificationARNs": [],
      "RollbackConfiguration": {},
      "Capabilities": [],
      "Tags": null
  }

# Deploy
./060_kinesis.sh deploy
  deploy mode

  Waiting for changeset to be created..
  Waiting for stack create/update to complete
  Successfully created/updated stack - dms-kinesis-kcl-kinesis


#############################################
# Cloud9の環境設定
#############################################

# コンソールからcloud9環境にアクセス
# commandOnCloud9.shのコマンドメモを参考に実行



#############################################
# DMSのデプロイとCDCの開始
#############################################

# 一応トラブルシューティング用にメモ：Resource creation will fail if the dms-vpc-role IAM role doesn't already exist.
# ↑のロールは作った記憶はないが、できていたので、コンソールからやったらできるのかもしれない

# Changesetの確認
./070_dms.sh

  Waiting for changeset to be created..
  Changeset created successfully. Run the following command to review changes:
  aws cloudformation describe-change-set --change-set-name arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620489005/c3a0e15d-6888-4c46-85de-9753f5c065c2

aws cloudformation describe-change-set --change-set-name arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620489005/c3a0e15d-6888-4c46-85de-9753f5c065c2
  {
      "Changes": [
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "dmsInstance",
                  "ResourceType": "AWS::DMS::ReplicationInstance",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "dmsReplicationTask",
                  "ResourceType": "AWS::DMS::ReplicationTask",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "dmsSubnetGroup",
                  "ResourceType": "AWS::DMS::ReplicationSubnetGroup",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "sourceEndpoint",
                  "ResourceType": "AWS::DMS::Endpoint",
                  "Scope": [],
                  "Details": []
              }
          },
          {
              "Type": "Resource",
              "ResourceChange": {
                  "Action": "Add",
                  "LogicalResourceId": "targetEndpoint",
                  "ResourceType": "AWS::DMS::Endpoint",
                  "Scope": [],
                  "Details": []
              }
          }
      ],
      "ChangeSetName": "awscli-cloudformation-package-deploy-1620489005",
      "ChangeSetId": "arn:aws:cloudformation:ap-northeast-1:147967438560:changeSet/awscli-cloudformation-package-deploy-1620489005/c3a0e15d-6888-4c46-85de-9753f5c065c2",
      "StackId": "arn:aws:cloudformation:ap-northeast-1:147967438560:stack/dms-kinesis-kcl-dms/911805f0-b013-11eb-bcf5-0a823c21513b",
      "StackName": "dms-kinesis-kcl-dms",
      "Description": "Created by AWS CLI at 2021-05-08T15:50:05.710977 UTC",
      "Parameters": [
          {
              "ParameterKey": "MasterUserPassword",
              "ParameterValue": "****"
          },
          {
              "ParameterKey": "Username",
              "ParameterValue": "postgres"
          },
          {
              "ParameterKey": "PJPrefix",
              "ParameterValue": "dms-kinesis-kcl"
          },
          {
              "ParameterKey": "DMSTableMapping",
              "ParameterValue": "{\"rules\":[{\"rule-type\":\"selection\",\"rule-id\":\"1\",\"rule-name\":\"1\",\"object-locator\":{\"schema-name\":\"public\",\"table-name\":\"source_tbl\"},\"rule-action\":\"include\",\"filters\":[]},{\"rule-type\":\"object-mapping\",\"rule-id\":\"2\",\"rule-name\":\"2\",\"rule-action\":\"map-record-to-record\",\"target-table-name\":\"source_tbl\",\"object-locator\":{\"schema-name\":\"public\",\"table-name\":\"source_tbl\"},\"mapping-parameters\":{\"partition-key-type\":\"schema-table\"}}]}"
          },
          {
              "ParameterKey": "DMSTaskSetting",
              "ParameterValue": "{\"TargetMetadata\":{\"TargetSchema\":\"\",\"SupportLobs\":true,\"FullLobMode\":false,\"LobChunkSize\":0,\"LimitedSizeLobMode\":true,\"LobMaxSize\":32,\"InlineLobMaxSize\":0,\"LoadMaxFileSize\":0,\"ParallelLoadThreads\":0,\"ParallelLoadBufferSize\":0,\"BatchApplyEnabled\":false,\"TaskRecoveryTableEnabled\":false,\"ParallelLoadQueuesPerThread\":0,\"ParallelApplyThreads\":0,\"ParallelApplyBufferSize\":0,\"ParallelApplyQueuesPerThread\":0},\"FullLoadSettings\":{\"TargetTablePrepMode\":\"DO_NOTHING\",\"CreatePkAfterFullLoad\":false,\"StopTaskCachedChangesApplied\":false,\"StopTaskCachedChangesNotApplied\":false,\"MaxFullLoadSubTasks\":8,\"TransactionConsistencyTimeout\":600,\"CommitRate\":10000},\"Logging\":{\"EnableLogging\":false,\"LogComponents\":[{\"Id\":\"TRANSFORMATION\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"},{\"Id\":\"SOURCE_UNLOAD\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"},{\"Id\":\"IO\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"},{\"Id\":\"TARGET_LOAD\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"},{\"Id\":\"PERFORMANCE\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"},{\"Id\":\"SOURCE_CAPTURE\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"},{\"Id\":\"SORTER\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"},{\"Id\":\"REST_SERVER\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"},{\"Id\":\"VALIDATOR_EXT\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"},{\"Id\":\"TARGET_APPLY\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"},{\"Id\":\"TASK_MANAGER\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"},{\"Id\":\"TABLES_MANAGER\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"},{\"Id\":\"METADATA_MANAGER\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"},{\"Id\":\"FILE_FACTORY\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"},{\"Id\":\"COMMON\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"},{\"Id\":\"ADDONS\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"},{\"Id\":\"DATA_STRUCTURE\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"},{\"Id\":\"COMMUNICATION\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"},{\"Id\":\"FILE_TRANSFER\",\"Severity\":\"LOGGER_SEVERITY_DEFAULT\"}],\"CloudWatchLogGroup\":null,\"CloudWatchLogStream\":null},\"ControlTablesSettings\":{\"historyTimeslotInMinutes\":5,\"ControlSchema\":\"\",\"HistoryTimeslotInMinutes\":5,\"HistoryTableEnabled\":false,\"SuspendedTablesTableEnabled\":false,\"StatusTableEnabled\":false,\"FullLoadExceptionTableEnabled\":false},\"StreamBufferSettings\":{\"StreamBufferCount\":3,\"StreamBufferSizeInMB\":8,\"CtrlStreamBufferSizeInMB\":5},\"ChangeProcessingDdlHandlingPolicy\":{\"HandleSourceTableDropped\":true,\"HandleSourceTableTruncated\":true,\"HandleSourceTableAltered\":true},\"ErrorBehavior\":{\"DataErrorPolicy\":\"LOG_ERROR\",\"DataTruncationErrorPolicy\":\"LOG_ERROR\",\"DataErrorEscalationPolicy\":\"SUSPEND_TABLE\",\"DataErrorEscalationCount\":0,\"TableErrorPolicy\":\"SUSPEND_TABLE\",\"TableErrorEscalationPolicy\":\"STOP_TASK\",\"TableErrorEscalationCount\":0,\"RecoverableErrorCount\":-1,\"RecoverableErrorInterval\":5,\"RecoverableErrorThrottling\":true,\"RecoverableErrorThrottlingMax\":1800,\"RecoverableErrorStopRetryAfterThrottlingMax\":true,\"ApplyErrorDeletePolicy\":\"IGNORE_RECORD\",\"ApplyErrorInsertPolicy\":\"LOG_ERROR\",\"ApplyErrorUpdatePolicy\":\"LOG_ERROR\",\"ApplyErrorEscalationPolicy\":\"LOG_ERROR\",\"ApplyErrorEscalationCount\":0,\"ApplyErrorFailOnTruncationDdl\":false,\"FullLoadIgnoreConflicts\":true,\"FailOnTransactionConsistencyBreached\":false,\"FailOnNoTablesCaptured\":true},\"ChangeProcessingTuning\":{\"BatchApplyPreserveTransaction\":true,\"BatchApplyTimeoutMin\":1,\"BatchApplyTimeoutMax\":30,\"BatchApplyMemoryLimit\":500,\"BatchSplitSize\":0,\"MinTransactionSize\":1000,\"CommitTimeout\":1,\"MemoryLimitTotal\":1024,\"MemoryKeepTime\":60,\"StatementCacheSize\":50},\"PostProcessingRules\":null,\"CharacterSetSettings\":null,\"LoopbackPreventionSettings\":null,\"BeforeImageSettings\":{\"EnableBeforeImage\":true,\"FieldName\":\"before-image\",\"ColumnFilter\":\"all\"},\"FailTaskWhenCleanTaskResourceFailed\":true}"
          }
      ],
      "CreationTime": "2021-05-08T15:50:07.406Z",
      "ExecutionStatus": "AVAILABLE",
      "Status": "CREATE_COMPLETE",
      "StatusReason": null,
      "NotificationARNs": [],
      "RollbackConfiguration": {},
      "Capabilities": [],
      "Tags": null
  }


# Deploy
./070_dms.sh deploy
  deploy mode

  Waiting for changeset to be created..
  Waiting for stack create/update to complete
  Successfully created/updated stack - dms-kinesis-kcl-dms


#############################################
# CDCタスクとKinesis Client Applicationの実行確認
#############################################

# マネジメントコンソールからDMSのタスクを確認し、アクションから「開始/再開」をクリックする
# しばらく経ってからステータスが、「レプリケーション進行中」になっていることを確認する

# Cloud9上でKCLアプリケーションを実行して動作確認をする



#############################################
# 環境の削除
#############################################

# DMSのタスクを停止した上で削除を開始すること
# DMSのスタックの削除に失敗するときは手動で削除した上でスタックを削除する

# 進行状況を確認しやすいので、コンソールからcloudformationのスタックを順次消していく
# エラーが出たらその内容に応じて対処する

# 手動で削除が必要なリソースは「環境削除.txt」を参照し、削除する


