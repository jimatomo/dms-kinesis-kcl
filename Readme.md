# dms-kinesis-kcl tutorial

CDC and Streming Sample Application on AWS


# Features

You can deploy sample application by cloudformation


# Requirement

Prepare your AWS Account and Administorator priviledge.

Prepare the environment which execute cloudformation (Bash script)
* aws cli 1.18.56 or later
* jq (for format json responce from aws cli)


# Usage

1) Deploy tutorial environment

```bash
git clone https://github.com/jimatomo/dms-kinesis-kcl.git
cd 100_cloudformation
./010_vpc.sh

...
```
(Please read interactive command text file "command.sh")


2) set up cloud9 environment
Please read interactive command text file "commandOnCloud9.sh"

Change The Endpoint address(in sample1_kcl_app.py and sample2_kcl_app.py)
```
        # DB connection parameters
        self.pghost = 'dms-kinesis-kcl-aurora-posgresql.cluster-coqptnsxlyvd.ap-northeast-1.rds.amazonaws.com'
        self.pgport = '5432'
        self.pgdbname = 'streaming_db'
        self.pguser = 'postgres'
        self.pgpassword = self.get_parameters('/dms-kinesis-kcl/aurora-admin-password')
```
# Note

After you finish tutorial, Delete the environment.

課金が発生するので、環境削除を忘れないようにしてください。

このチュートリアルの詳細は以下のブログに書いておきます。
https://jimatomo.hatenablog.com/entry/aws/dms-kinesis-kcl