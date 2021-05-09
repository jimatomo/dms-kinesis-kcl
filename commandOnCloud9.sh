#############################################
# Cloud9の環境設定
#############################################

#--------------------------------------------
# Cloud9のIAM設定
#--------------------------------------------

# コンソールからcloud9環境にアクセス
# IAMのキーの設定をする
# 左上の「AWS Cloud9」から「Preferences」を開く
# [AWS SETTINGS]を開き、「Credentials」をオフにする

# インスタンスプロファイルを使用していることを確認
aws configure list
        Name                    Value             Type    Location
        ----                    -----             ----    --------
    profile                <not set>             None    None
  access_key     ****************DVDU         iam-role
  secret_key     ****************igo/         iam-role
      region                <not set>             None    None

# regionを設定する
aws configure set region ap-northeast-1

aws configure list
        Name                    Value             Type    Location
        ----                    -----             ----    --------
    profile                <not set>             None    None
  access_key     ****************DVDU         iam-role
  secret_key     ****************igo/         iam-role
      region           ap-northeast-1      config-file    ~/.aws/config


#--------------------------------------------
# psqlのインストール
#--------------------------------------------

# RHEL7と互換のAmazon Linux2を利用しているため、RHELと同じリポジトリを登録する
sudo rpm -ivh --nodeps https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

  Retrieving https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
  warning: /var/tmp/rpm-tmp.lMnwok: Header V4 DSA/SHA1 Signature, key ID 442df0f8: NOKEY
  Preparing...                          ################################# [100%]
  Updating / installing...
    1:pgdg-redhat-repo-42.0-14         ################################# [100%]

# 確認
yum list installed | grep pgdg
  pgdg-redhat-repo.noarch               42.0-14                        installed

rpm -ql pgdg-redhat-repo
  /etc/pki/rpm-gpg
  /etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG
  /etc/yum.repos.d/pgdg-redhat-all.repo

# yumの設定を修正（Amazon Linux2の独特の手順）
cat /etc/yum.repos.d/pgdg-redhat-all.repo
  (-----割愛-----)

sudo sed -i 's/\$releasever/7/g' /etc/yum.repos.d/pgdg-redhat-all.repo

head /etc/yum.repos.d/pgdg-redhat-all.repo
  #######################################################
  # PGDG Red Hat Enterprise Linux / CentOS repositories #
  #######################################################

  # PGDG Red Hat Enterprise Linux / CentOS stable common repository for all PostgreSQL versions

  [pgdg-common]
  name=PostgreSQL common RPMs for RHEL/CentOS 7 - $basearch
  baseurl=https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-7-$basearch
  enabled=1


# yumでのインストール
sudo yum install -y postgresql11.x86_64
  (-----割愛-----)

yum list installed | grep postgresql
  postgresql11.x86_64                   11.11-1PGDG.rhel7              @pgdg11
  postgresql11-libs.x86_64              11.11-1PGDG.rhel7              @pgdg11

# 確認
psql --version
  psql (PostgreSQL) 11.11


#--------------------------------------------
# psycopg2のインストール
#--------------------------------------------

# psycopg2-binaryをpipでインストール

# 仮想環境の作成
python3 -m venv kcl

cd kcl
source ./bin/activate


pip list
  Package    Version
  ---------- -------
  pip        20.1.1
  setuptools 47.1.0


pip install psycopg2-binary
  Collecting psycopg2-binary
    Downloading psycopg2_binary-2.8.6-cp37-cp37m-manylinux1_x86_64.whl (3.0 MB)
      |████████████████████████████████| 3.0 MB 13.8 MB/s
  Installing collected packages: psycopg2-binary
  Successfully installed psycopg2-binary-2.8.6


pip list
  Package         Version
  --------------- -------
  pip             20.1.1
  psycopg2-binary 2.8.6
  setuptools      47.1.0


#--------------------------------------------
# KCL (Kinesis Client Library)のインストール
#--------------------------------------------

# 以下の手順でインストール可能
# 実行済みのものはコメントアウト
# sudo yum install python-pip
# sudo pip install virtualenv
# virtualenv /tmp/kclpy-sample-env
# source /tmp/kclpy-sample-env/bin/activate

# pipでインストール（setup.pyの実行で少し時間がかかるので小休憩）
pip install amazon_kclpy
  Collecting amazon_kclpy
    Downloading amazon_kclpy-2.0.1.tar.gz (28 kB)
  Collecting boto
    Downloading boto-2.49.0-py2.py3-none-any.whl (1.4 MB)
      |████████████████████████████████| 1.4 MB 12.0 MB/s
  Collecting argparse
    Downloading argparse-1.4.0-py2.py3-none-any.whl (23 kB)
  Using legacy setup.py install for amazon-kclpy, since package 'wheel' is not installed.
  Installing collected packages: boto, argparse, amazon-kclpy
      Running setup.py install for amazon-kclpy ... done
  Successfully installed amazon-kclpy-2.0.1 argparse-1.4.0 boto-2.49.0


#--------------------------------------------
# boto3のインストール
#--------------------------------------------

# pipでインストール
pip install boto3
  Collecting boto3
    Downloading boto3-1.17.69-py2.py3-none-any.whl (131 kB)
      |████████████████████████████████| 131 kB 13.1 MB/s
  Collecting jmespath<1.0.0,>=0.7.1
    Downloading jmespath-0.10.0-py2.py3-none-any.whl (24 kB)
  Collecting botocore<1.21.0,>=1.20.69
    Downloading botocore-1.20.69-py2.py3-none-any.whl (7.5 MB)
      |████████████████████████████████| 7.5 MB 14.1 MB/s
  Collecting s3transfer<0.5.0,>=0.4.0
    Downloading s3transfer-0.4.2-py2.py3-none-any.whl (79 kB)
      |████████████████████████████████| 79 kB 15.0 MB/s
  Collecting urllib3<1.27,>=1.25.4
    Downloading urllib3-1.26.4-py2.py3-none-any.whl (153 kB)
      |████████████████████████████████| 153 kB 63.5 MB/s
  Collecting python-dateutil<3.0.0,>=2.1
    Downloading python_dateutil-2.8.1-py2.py3-none-any.whl (227 kB)
      |████████████████████████████████| 227 kB 58.4 MB/s
  Collecting six>=1.5
    Downloading six-1.16.0-py2.py3-none-any.whl (11 kB)
  Installing collected packages: jmespath, urllib3, six, python-dateutil, botocore, s3transfer, boto3
  Successfully installed boto3-1.17.69 botocore-1.20.69 jmespath-0.10.0 python-dateutil-2.8.1 s3transfer-0.4.2 six-1.16.0 urllib3-1.26.4


#--------------------------------------------
# jqのインストール
#--------------------------------------------

sudo yum -y install jq
  (-----割愛-----)

jq --version
  jq-1.5


#--------------------------------------------
# Javaのインストール
#--------------------------------------------

# Javaのバージョンを確認
java --version
  openjdk 11.0.11 2021-04-20 LTS
  OpenJDK Runtime Environment Corretto-11.0.11.9.1 (build 11.0.11+9-LTS)
  OpenJDK 64-Bit Server VM Corretto-11.0.11.9.1 (build 11.0.11+9-LTS, mixed mode)

# PATHの確認（KCLアプリケーション実行時に指定）
which java
  /usr/bin/java

# インストール不要


#############################################
# Aurora Clusterの設定
#############################################

#-------------------------------------------
# Upload DDL SQL text file
#-------------------------------------------

# メニューバーの"File"から"Upload local files..."を選択
ls -l dms-kinesis-setup.sql
  -rw-r--r-- 1 ec2-user ec2-user 1021 May  8 15:24 dms-kinesis-setup.sql

#-------------------------------------------
# connect to aurora instance
#-------------------------------------------

# Set your Aurora cloudformation Stack Name below
export AURORA_CFN_STACK_NAME=dms-kinesis-kcl-aurora
export PGHOST=`aws cloudformation describe-stacks --stack-name ${AURORA_CFN_STACK_NAME} --query Stacks[*].Outputs | jq .[0] | jq 'map(select( .OutputKey == "auroraClusterEndpoint" ))' | jq -r .[0].OutputValue`
# Set your Aurora master user name
export PGUSER=postgres
# Set your SSM Parameter Name (Aurora Master User Password)
export MASTER_PASSWD=/dms-kinesis-kcl/aurora-admin-password
export PGPASSWORD=`aws ssm get-parameter --name ${MASTER_PASSWD} --with-decryption --query Parameter.Value --output text`
# Set Database name and Port number below
export PGDATABASE=streaming_db
export PGPORT=5432


psql

\pset x auto
\pset pager off
\conninfo

--#-------------------------------------------------
--# 論理レプリケーションのプラグインの設定
--#-------------------------------------------------

-- check extections
  select * FROM pg_catalog.pg_extension;
  extname | extowner | extnamespace | extrelocatable | extversion | extconfig | extcondition
  ---------+----------+--------------+----------------+------------+-----------+--------------
  plpgsql |       10 |           11 | f              | 1.0        |           |
  (1 row)


create extension pglogical;
  CREATE EXTENSION

-- check extections
select * FROM pg_catalog.pg_extension;
    extname  | extowner | extnamespace | extrelocatable | extversion | extconfig | extcondition
  -----------+----------+--------------+----------------+------------+-----------+--------------
  plpgsql   |       10 |           11 | f              | 1.0        |           |
  pglogical |       10 |        20490 | f              | 2.2.2      |           |
  (2 rows)


--#-------------------------------------------------
--# 論理レプリケーションのプラグインの設定
--#-------------------------------------------------

\q

# pglogicalのノードを作成
psql << EOF
  SELECT pglogical.create_node(
    node_name := 'provider1',
    dsn := 'host=${PGHOST} port=5432 dbname=${PGDATABASE} user=${PGUSER}'
  );
EOF
  create_node
  -------------
    2976894835
  (1 row)


psql
\pset x auto
\pset pager off
\conninfo


--# 確認
SELECT * FROM pglogical.node_interface;
    if_id    |  if_name  | if_nodeid  |                                                                 if_dsn
  ------------+-----------+------------+-----------------------------------------------------------------------------------------------------------------------------------------
  2402836775 | provider1 | 2976894835 | host=dms-kinesis-kcl-aurora-posgresql.cluster-coqptnsxlyvd.ap-northeast-1.rds.amazonaws.com port=5432 dbname=streaming_db user=postgres
  (1 row)

--#-------------------------------------------------
--# DDLの実行
--#-------------------------------------------------

\i dms-kinesis-setup.sql


--##################################################
-- ここまでやった後に、DMSのデプロイを実施
--##################################################



--#-------------------------------------------------
--# 論理レプリケーションスロットの状態を確認
--#-------------------------------------------------

--# active列がtになっているとレプリケーションスロットが正常に利用されている
SELECT * FROM pg_replication_slots;
                          slot_name                          |  plugin   | slot_type | datoid |   database   | temporary | active | active_pid | xmin | catalog_xmin | restart_lsn | confirmed_flush_lsn
  ------------------------------------------------------------+-----------+-----------+--------+--------------+-----------+--------+------------+------+--------------+-------------+---------------------
  dms_task_001_00016400_c7222aa5_1e59_4a57_b606_74e95cc4b228 | pglogical | logical   |  16400 | streaming_db | f         | t      |       9796 |      |        42491 | 0/451AEA8   | 0/451BE48
  (1 row)



\q




#############################################
# KCLの実行
#############################################

# データベースの接続パラメータやKinesis Data Streamsのストリーム名を変更した場合などはソースコードやプロパティファイルなどを書き換えること
# sampleX.propertyファイルにKinesisの設定があり、
# sampleX_kclpy_app.pyのRecordProcessorクラスのinitメソッド内にDB接続パラメータの設定がある

# KCLのプログラムのデプロイ
ls -l

tar -xf dms-kinesis-kcl_sample.tar

ls -l
  total 72
  -rwxrwxr-x 1 ec2-user ec2-user  7161 May  7 07:08 amazon_kclpy_helper.py
  drwxrwxr-x 3 ec2-user ec2-user  4096 May  8 15:21 bin
  -rw-r--r-- 1 ec2-user ec2-user 51712 May  8 15:24 dms-kinesis-kcl_sample.tar
  -rw-r--r-- 1 ec2-user ec2-user  1021 May  8 15:24 dms-kinesis-setup.sql
  drwxrwxr-x 2 ec2-user ec2-user     6 May  8 15:16 include
  drwxrwxr-x 3 ec2-user ec2-user    23 May  8 15:16 lib
  lrwxrwxrwx 1 ec2-user ec2-user     3 May  8 15:16 lib64 -> lib
  -rw-rw-r-- 1 ec2-user ec2-user    69 May  8 15:16 pyvenv.cfg
  drwxrwxr-x 2 ec2-user ec2-user    60 May  7 06:15 sample1
  drwxrwxr-x 2 ec2-user ec2-user    90 May  7 05:18 sample2


# sample1の実行
`amazon_kclpy_helper.py --print_command --java /usr/bin/java --properties sample1/sample1.properties`
  2021-05-08 16:05:49,801 [main] INFO  s.a.k.m.MultiLangDaemonConfig [NONE] - Using a cached thread pool.
  2021-05-08 16:05:50,068 [main] INFO  s.a.k.m.MultiLangDaemonConfig [NONE] - Running PythonKCLSample1 to process stream dms-kinesis-kcl-kds-001 with executable /home/ec2-user/environment/kcl/sample1/sample1_kclpy_app.py
  2021-05-08 16:05:50,078 [main] INFO  s.a.k.m.MultiLangDaemonConfig [NONE] - Using workerId: c0a606a7-ac80-4ce6-ba11-940aaee74c75
  2021-05-08 16:05:50,078 [main] INFO  s.a.k.m.MultiLangDaemonConfig [NONE] - MultiLangDaemon is adding the following fields to the User Agent: amazon-kinesis-client-library-java amazon-kinesis-multi-lang-daemon/1.0.1 python/3.7 /home/ec2-user/environment/kcl/sample1/sample1_kclpy_app.py
  2021-05-08 16:05:50,798 [main] INFO  s.a.k.l.d.DynamoDBLeaseCoordinator [NONE] - With failover time 10000 ms and epsilon 25 ms, LeaseCoordinator will renew leases every 3308 ms, takeleases every 20050 ms, process maximum of 2147483647 leases and steal 1 lease(s) at a time.
  2021-05-08 16:05:50,806 [multi-lang-daemon-0000] INFO  s.a.kinesis.coordinator.Scheduler [NONE] - Initialization attempt 1
  2021-05-08 16:05:50,807 [multi-lang-daemon-0000] INFO  s.a.kinesis.coordinator.Scheduler [NONE] - Initializing LeaseCoordinator
  May 08, 2021 4:05:50 PM com.amazonaws.profile.path.cred.CredentialsLegacyConfigLocationProvider getLocation
  WARNING: Found the legacy config profiles file at [/home/ec2-user/.aws/config]. Please move it to the latest default location [~/.aws/credentials].
  2021-05-08 16:05:52,826 [multi-lang-daemon-0000] INFO  s.a.k.l.d.DynamoDBLeaseCoordinator [NONE] - Created new lease table for coordinator with initial read capacity of 10 and write capacity of 10.
  2021-05-08 16:06:02,881 [multi-lang-daemon-0000] INFO  s.a.kinesis.coordinator.Scheduler [NONE] - Syncing Kinesis shard info
  2021-05-08 16:06:03,394 [multi-lang-daemon-0000] INFO  s.a.kinesis.coordinator.Scheduler [NONE] - Starting LeaseCoordinator
  2021-05-08 16:06:03,454 [LeaseCoordinator-0000] INFO  s.a.k.l.dynamodb.DynamoDBLeaseTaker [NONE] - Worker c0a606a7-ac80-4ce6-ba11-940aaee74c75 saw 1 total leases, 1 available leases, 1 workers. Target is 1 leases, I have 0 leases, I will take 1 leases
  2021-05-08 16:06:03,502 [LeaseCoordinator-0000] INFO  s.a.k.l.dynamodb.DynamoDBLeaseTaker [NONE] - Worker c0a606a7-ac80-4ce6-ba11-940aaee74c75 successfully took 1 leases: shardId-000000000000
  2021-05-08 16:06:13,432 [multi-lang-daemon-0000] INFO  s.a.kinesis.coordinator.Scheduler [NONE] - Initialization complete. Starting worker loop.
  2021-05-08 16:06:13,662 [multi-lang-daemon-0000] INFO  s.a.k.r.f.FanOutConsumerRegistration [NONE] - StreamConsumer not found, need to create it.
  2021-05-08 16:06:13,946 [multi-lang-daemon-0000] ERROR s.a.k.r.f.FanOutConsumerRegistration [NONE] - Status of StreamConsumer PythonKCLSample1, was not ACTIVE after all retries. Was instead CREATING.
  2021-05-08 16:06:13,949 [multi-lang-daemon-0000] ERROR s.a.kinesis.coordinator.Scheduler [NONE] - Worker.run caught exception, sleeping for 1000 milli seconds!
  java.lang.IllegalStateException: Status of StreamConsumer PythonKCLSample1, was not ACTIVE after all retries. Was instead CREATING.
          at software.amazon.kinesis.retrieval.fanout.FanOutConsumerRegistration.waitForActive(FanOutConsumerRegistration.java:162)
          at software.amazon.kinesis.retrieval.fanout.FanOutConsumerRegistration.getOrCreateStreamConsumerArn(FanOutConsumerRegistration.java:111)
          at software.amazon.kinesis.retrieval.fanout.FanOutConfig.getOrCreateConsumerArn(FanOutConfig.java:95)
          at software.amazon.kinesis.retrieval.fanout.FanOutConfig.retrievalFactory(FanOutConfig.java:85)
          at software.amazon.kinesis.retrieval.RetrievalConfig.retrievalFactory(RetrievalConfig.java:94)
          at software.amazon.kinesis.coordinator.Scheduler.buildConsumer(Scheduler.java:561)
          at software.amazon.kinesis.coordinator.Scheduler.createOrGetShardConsumer(Scheduler.java:552)
          at software.amazon.kinesis.coordinator.Scheduler.runProcessLoop(Scheduler.java:290)
          at software.amazon.kinesis.coordinator.Scheduler.run(Scheduler.java:222)
          at software.amazon.kinesis.multilang.MultiLangDaemon$MultiLangRunner.call(MultiLangDaemon.java:95)
          at software.amazon.kinesis.multilang.MultiLangDaemon$MultiLangRunner.call(MultiLangDaemon.java:86)
          at java.base/java.util.concurrent.FutureTask.run(FutureTask.java:264)
          at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128)
          at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628)
          at java.base/java.lang.Thread.run(Thread.java:829)
  2021-05-08 16:06:15,171 [multi-lang-daemon-0000] ERROR s.a.k.r.f.FanOutConsumerRegistration [NONE] - Status of StreamConsumer PythonKCLSample1, was not ACTIVE after all retries. Was instead CREATING.
  2021-05-08 16:06:15,172 [multi-lang-daemon-0000] ERROR s.a.kinesis.coordinator.Scheduler [NONE] - Worker.run caught exception, sleeping for 1000 milli seconds!
  java.lang.IllegalStateException: Status of StreamConsumer PythonKCLSample1, was not ACTIVE after all retries. Was instead CREATING.
          at software.amazon.kinesis.retrieval.fanout.FanOutConsumerRegistration.waitForActive(FanOutConsumerRegistration.java:162)
          at software.amazon.kinesis.retrieval.fanout.FanOutConsumerRegistration.getOrCreateStreamConsumerArn(FanOutConsumerRegistration.java:111)
          at software.amazon.kinesis.retrieval.fanout.FanOutConfig.getOrCreateConsumerArn(FanOutConfig.java:95)
          at software.amazon.kinesis.retrieval.fanout.FanOutConfig.retrievalFactory(FanOutConfig.java:85)
          at software.amazon.kinesis.retrieval.RetrievalConfig.retrievalFactory(RetrievalConfig.java:94)
          at software.amazon.kinesis.coordinator.Scheduler.buildConsumer(Scheduler.java:561)
          at software.amazon.kinesis.coordinator.Scheduler.createOrGetShardConsumer(Scheduler.java:552)
          at software.amazon.kinesis.coordinator.Scheduler.runProcessLoop(Scheduler.java:290)
          at software.amazon.kinesis.coordinator.Scheduler.run(Scheduler.java:222)
          at software.amazon.kinesis.multilang.MultiLangDaemon$MultiLangRunner.call(MultiLangDaemon.java:95)
          at software.amazon.kinesis.multilang.MultiLangDaemon$MultiLangRunner.call(MultiLangDaemon.java:86)
          at java.base/java.util.concurrent.FutureTask.run(FutureTask.java:264)
          at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128)
          at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628)
          at java.base/java.lang.Thread.run(Thread.java:829)
  2021-05-08 16:06:16,369 [multi-lang-daemon-0000] ERROR s.a.k.r.f.FanOutConsumerRegistration [NONE] - Status of StreamConsumer PythonKCLSample1, was not ACTIVE after all retries. Was instead CREATING.
  2021-05-08 16:06:16,370 [multi-lang-daemon-0000] ERROR s.a.kinesis.coordinator.Scheduler [NONE] - Worker.run caught exception, sleeping for 1000 milli seconds!
  java.lang.IllegalStateException: Status of StreamConsumer PythonKCLSample1, was not ACTIVE after all retries. Was instead CREATING.
          at software.amazon.kinesis.retrieval.fanout.FanOutConsumerRegistration.waitForActive(FanOutConsumerRegistration.java:162)
          at software.amazon.kinesis.retrieval.fanout.FanOutConsumerRegistration.getOrCreateStreamConsumerArn(FanOutConsumerRegistration.java:111)
          at software.amazon.kinesis.retrieval.fanout.FanOutConfig.getOrCreateConsumerArn(FanOutConfig.java:95)
          at software.amazon.kinesis.retrieval.fanout.FanOutConfig.retrievalFactory(FanOutConfig.java:85)
          at software.amazon.kinesis.retrieval.RetrievalConfig.retrievalFactory(RetrievalConfig.java:94)
          at software.amazon.kinesis.coordinator.Scheduler.buildConsumer(Scheduler.java:561)
          at software.amazon.kinesis.coordinator.Scheduler.createOrGetShardConsumer(Scheduler.java:552)
          at software.amazon.kinesis.coordinator.Scheduler.runProcessLoop(Scheduler.java:290)
          at software.amazon.kinesis.coordinator.Scheduler.run(Scheduler.java:222)
          at software.amazon.kinesis.multilang.MultiLangDaemon$MultiLangRunner.call(MultiLangDaemon.java:95)
          at software.amazon.kinesis.multilang.MultiLangDaemon$MultiLangRunner.call(MultiLangDaemon.java:86)
          at java.base/java.util.concurrent.FutureTask.run(FutureTask.java:264)
          at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128)
          at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628)
          at java.base/java.lang.Thread.run(Thread.java:829)
  2021-05-08 16:06:17,561 [multi-lang-daemon-0000] ERROR s.a.k.r.f.FanOutConsumerRegistration [NONE] - Status of StreamConsumer PythonKCLSample1, was not ACTIVE after all retries. Was instead CREATING.
  2021-05-08 16:06:17,562 [multi-lang-daemon-0000] ERROR s.a.kinesis.coordinator.Scheduler [NONE] - Worker.run caught exception, sleeping for 1000 milli seconds!
  java.lang.IllegalStateException: Status of StreamConsumer PythonKCLSample1, was not ACTIVE after all retries. Was instead CREATING.
          at software.amazon.kinesis.retrieval.fanout.FanOutConsumerRegistration.waitForActive(FanOutConsumerRegistration.java:162)
          at software.amazon.kinesis.retrieval.fanout.FanOutConsumerRegistration.getOrCreateStreamConsumerArn(FanOutConsumerRegistration.java:111)
          at software.amazon.kinesis.retrieval.fanout.FanOutConfig.getOrCreateConsumerArn(FanOutConfig.java:95)
          at software.amazon.kinesis.retrieval.fanout.FanOutConfig.retrievalFactory(FanOutConfig.java:85)
          at software.amazon.kinesis.retrieval.RetrievalConfig.retrievalFactory(RetrievalConfig.java:94)
          at software.amazon.kinesis.coordinator.Scheduler.buildConsumer(Scheduler.java:561)
          at software.amazon.kinesis.coordinator.Scheduler.createOrGetShardConsumer(Scheduler.java:552)
          at software.amazon.kinesis.coordinator.Scheduler.runProcessLoop(Scheduler.java:290)
          at software.amazon.kinesis.coordinator.Scheduler.run(Scheduler.java:222)
          at software.amazon.kinesis.multilang.MultiLangDaemon$MultiLangRunner.call(MultiLangDaemon.java:95)
          at software.amazon.kinesis.multilang.MultiLangDaemon$MultiLangRunner.call(MultiLangDaemon.java:86)
          at java.base/java.util.concurrent.FutureTask.run(FutureTask.java:264)
          at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128)
          at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628)
          at java.base/java.lang.Thread.run(Thread.java:829)
  2021-05-08 16:06:18,645 [multi-lang-daemon-0000] INFO  s.a.kinesis.coordinator.Scheduler [NONE] - Created new shardConsumer for : ShardInfo(shardId=shardId-000000000000, concurrencyToken=57538e66-d27a-4541-b83e-46afe3c0ddfa, parentShardIds=[], checkpoint={SequenceNumber: TRIM_HORIZON,SubsequenceNumber: 0})
  2021-05-08 16:06:18,649 [ShardRecordProcessor-0000] INFO  s.a.k.l.BlockOnParentShardTask [NONE] - No need to block on parents [] of shard shardId-000000000000
  2021-05-08 16:06:19,699 [ShardRecordProcessor-0000] INFO  s.a.kinesis.multilang.MessageWriter [NONE] - Writing InitializeMessage to child process for shard shardId-000000000000
  2021-05-08 16:06:19,702 [multi-lang-daemon-0001] INFO  s.a.kinesis.multilang.LineReaderTask [NONE] - Starting: Reading STDERR for shardId-000000000000
  2021-05-08 16:06:19,822 [multi-lang-daemon-0002] INFO  s.a.kinesis.multilang.MessageWriter [NONE] - Message size == 110 bytes for shard shardId-000000000000
  2021-05-08 16:06:19,826 [multi-lang-daemon-0003] INFO  s.a.kinesis.multilang.LineReaderTask [NONE] - Starting: Reading next message from STDIN for shardId-000000000000
  2021-05-08 16:06:20,446 [ShardRecordProcessor-0000] INFO  s.a.k.multilang.MultiLangProtocol [NONE] - Received response {"action":"status","responseFor":"initialize"} from subprocess while waiting for initialize while processing shard shardId-000000000000
  2021-05-08 16:06:21,879 [ShardRecordProcessor-0001] INFO  s.a.kinesis.multilang.MessageWriter [NONE] - Writing ProcessRecordsMessage to child process for shard shardId-000000000000
  2021-05-08 16:06:21,903 [multi-lang-daemon-0003] INFO  s.a.kinesis.multilang.MessageWriter [NONE] - Message size == 1101 bytes for shard shardId-000000000000
  2021-05-08 16:06:21,904 [multi-lang-daemon-0003] INFO  s.a.kinesis.multilang.LineReaderTask [NONE] - Starting: Reading next message from STDIN for shardId-000000000000
  2021-05-08 16:06:21,906 [ShardRecordProcessor-0001] INFO  s.a.k.multilang.MultiLangProtocol [NONE] - Received response {"action":"status","responseFor":"processRecords"} from subprocess while waiting for processRecords while processing shard shardId-000000000000
  2021-05-08 16:06:51,780 [multi-lang-daemon-0000] INFO  s.a.kinesis.coordinator.Scheduler [NONE] - Current stream shard assignments: shardId-000000000000
  2021-05-08 16:06:51,780 [multi-lang-daemon-0000] INFO  s.a.kinesis.coordinator.Scheduler [NONE] - Sleeping ...

# sample2の実行（別ターミナルで実行）
cd kcl
source ./bin/activate
`amazon_kclpy_helper.py --print_command --java /usr/bin/java --properties sample2/sample2.properties`
  2021-05-08 16:07:11,605 [main] INFO  s.a.k.m.MultiLangDaemonConfig [NONE] - Using a cached thread pool.
  2021-05-08 16:07:11,815 [main] INFO  s.a.k.m.MultiLangDaemonConfig [NONE] - Running PythonKCLSample2 to process stream dms-kinesis-kcl-kds-001 with executable /home/ec2-user/environment/kcl/sample2/sample2_kclpy_app.py
  2021-05-08 16:07:11,825 [main] INFO  s.a.k.m.MultiLangDaemonConfig [NONE] - Using workerId: d06c8549-bfd9-4e76-b767-09feefd02509
  2021-05-08 16:07:11,826 [main] INFO  s.a.k.m.MultiLangDaemonConfig [NONE] - MultiLangDaemon is adding the following fields to the User Agent: amazon-kinesis-client-library-java amazon-kinesis-multi-lang-daemon/1.0.1 python/3.7 /home/ec2-user/environment/kcl/sample2/sample2_kclpy_app.py
  2021-05-08 16:07:12,381 [main] INFO  s.a.k.l.d.DynamoDBLeaseCoordinator [NONE] - With failover time 10000 ms and epsilon 25 ms, LeaseCoordinator will renew leases every 3308 ms, takeleases every 20050 ms, process maximum of 2147483647 leases and steal 1 lease(s) at a time.
  2021-05-08 16:07:12,388 [multi-lang-daemon-0000] INFO  s.a.kinesis.coordinator.Scheduler [NONE] - Initialization attempt 1
  2021-05-08 16:07:12,388 [multi-lang-daemon-0000] INFO  s.a.kinesis.coordinator.Scheduler [NONE] - Initializing LeaseCoordinator
  May 08, 2021 4:07:12 PM com.amazonaws.profile.path.cred.CredentialsLegacyConfigLocationProvider getLocation
  WARNING: Found the legacy config profiles file at [/home/ec2-user/.aws/config]. Please move it to the latest default location [~/.aws/credentials].
  2021-05-08 16:07:14,174 [multi-lang-daemon-0000] INFO  s.a.k.l.d.DynamoDBLeaseCoordinator [NONE] - Created new lease table for coordinator with initial read capacity of 10 and write capacity of 10.
  2021-05-08 16:07:24,213 [multi-lang-daemon-0000] INFO  s.a.kinesis.coordinator.Scheduler [NONE] - Syncing Kinesis shard info
  2021-05-08 16:07:24,731 [multi-lang-daemon-0000] INFO  s.a.kinesis.coordinator.Scheduler [NONE] - Starting LeaseCoordinator
  2021-05-08 16:07:24,784 [LeaseCoordinator-0000] INFO  s.a.k.l.dynamodb.DynamoDBLeaseTaker [NONE] - Worker d06c8549-bfd9-4e76-b767-09feefd02509 saw 1 total leases, 1 available leases, 1 workers. Target is 1 leases, I have 0 leases, I will take 1 leases
  2021-05-08 16:07:24,838 [LeaseCoordinator-0000] INFO  s.a.k.l.dynamodb.DynamoDBLeaseTaker [NONE] - Worker d06c8549-bfd9-4e76-b767-09feefd02509 successfully took 1 leases: shardId-000000000000
  2021-05-08 16:07:34,767 [multi-lang-daemon-0000] INFO  s.a.kinesis.coordinator.Scheduler [NONE] - Initialization complete. Starting worker loop.
  2021-05-08 16:07:34,990 [multi-lang-daemon-0000] INFO  s.a.k.r.f.FanOutConsumerRegistration [NONE] - StreamConsumer not found, need to create it.
  2021-05-08 16:07:35,286 [multi-lang-daemon-0000] ERROR s.a.k.r.f.FanOutConsumerRegistration [NONE] - Status of StreamConsumer PythonKCLSample2, was not ACTIVE after all retries. Was instead CREATING.
  2021-05-08 16:07:35,289 [multi-lang-daemon-0000] ERROR s.a.kinesis.coordinator.Scheduler [NONE] - Worker.run caught exception, sleeping for 1000 milli seconds!
  java.lang.IllegalStateException: Status of StreamConsumer PythonKCLSample2, was not ACTIVE after all retries. Was instead CREATING.
          at software.amazon.kinesis.retrieval.fanout.FanOutConsumerRegistration.waitForActive(FanOutConsumerRegistration.java:162)
          at software.amazon.kinesis.retrieval.fanout.FanOutConsumerRegistration.getOrCreateStreamConsumerArn(FanOutConsumerRegistration.java:111)
          at software.amazon.kinesis.retrieval.fanout.FanOutConfig.getOrCreateConsumerArn(FanOutConfig.java:95)
          at software.amazon.kinesis.retrieval.fanout.FanOutConfig.retrievalFactory(FanOutConfig.java:85)
          at software.amazon.kinesis.retrieval.RetrievalConfig.retrievalFactory(RetrievalConfig.java:94)
          at software.amazon.kinesis.coordinator.Scheduler.buildConsumer(Scheduler.java:561)
          at software.amazon.kinesis.coordinator.Scheduler.createOrGetShardConsumer(Scheduler.java:552)
          at software.amazon.kinesis.coordinator.Scheduler.runProcessLoop(Scheduler.java:290)
          at software.amazon.kinesis.coordinator.Scheduler.run(Scheduler.java:222)
          at software.amazon.kinesis.multilang.MultiLangDaemon$MultiLangRunner.call(MultiLangDaemon.java:95)
          at software.amazon.kinesis.multilang.MultiLangDaemon$MultiLangRunner.call(MultiLangDaemon.java:86)
          at java.base/java.util.concurrent.FutureTask.run(FutureTask.java:264)
          at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128)
          at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628)
          at java.base/java.lang.Thread.run(Thread.java:829)
  2021-05-08 16:07:36,509 [multi-lang-daemon-0000] ERROR s.a.k.r.f.FanOutConsumerRegistration [NONE] - Status of StreamConsumer PythonKCLSample2, was not ACTIVE after all retries. Was instead CREATING.
  2021-05-08 16:07:36,510 [multi-lang-daemon-0000] ERROR s.a.kinesis.coordinator.Scheduler [NONE] - Worker.run caught exception, sleeping for 1000 milli seconds!
  java.lang.IllegalStateException: Status of StreamConsumer PythonKCLSample2, was not ACTIVE after all retries. Was instead CREATING.
          at software.amazon.kinesis.retrieval.fanout.FanOutConsumerRegistration.waitForActive(FanOutConsumerRegistration.java:162)
          at software.amazon.kinesis.retrieval.fanout.FanOutConsumerRegistration.getOrCreateStreamConsumerArn(FanOutConsumerRegistration.java:111)
          at software.amazon.kinesis.retrieval.fanout.FanOutConfig.getOrCreateConsumerArn(FanOutConfig.java:95)
          at software.amazon.kinesis.retrieval.fanout.FanOutConfig.retrievalFactory(FanOutConfig.java:85)
          at software.amazon.kinesis.retrieval.RetrievalConfig.retrievalFactory(RetrievalConfig.java:94)
          at software.amazon.kinesis.coordinator.Scheduler.buildConsumer(Scheduler.java:561)
          at software.amazon.kinesis.coordinator.Scheduler.createOrGetShardConsumer(Scheduler.java:552)
          at software.amazon.kinesis.coordinator.Scheduler.runProcessLoop(Scheduler.java:290)
          at software.amazon.kinesis.coordinator.Scheduler.run(Scheduler.java:222)
          at software.amazon.kinesis.multilang.MultiLangDaemon$MultiLangRunner.call(MultiLangDaemon.java:95)
          at software.amazon.kinesis.multilang.MultiLangDaemon$MultiLangRunner.call(MultiLangDaemon.java:86)
          at java.base/java.util.concurrent.FutureTask.run(FutureTask.java:264)
          at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128)
          at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628)
          at java.base/java.lang.Thread.run(Thread.java:829)
  2021-05-08 16:07:37,701 [multi-lang-daemon-0000] ERROR s.a.k.r.f.FanOutConsumerRegistration [NONE] - Status of StreamConsumer PythonKCLSample2, was not ACTIVE after all retries. Was instead CREATING.
  2021-05-08 16:07:37,702 [multi-lang-daemon-0000] ERROR s.a.kinesis.coordinator.Scheduler [NONE] - Worker.run caught exception, sleeping for 1000 milli seconds!
  java.lang.IllegalStateException: Status of StreamConsumer PythonKCLSample2, was not ACTIVE after all retries. Was instead CREATING.
          at software.amazon.kinesis.retrieval.fanout.FanOutConsumerRegistration.waitForActive(FanOutConsumerRegistration.java:162)
          at software.amazon.kinesis.retrieval.fanout.FanOutConsumerRegistration.getOrCreateStreamConsumerArn(FanOutConsumerRegistration.java:111)
          at software.amazon.kinesis.retrieval.fanout.FanOutConfig.getOrCreateConsumerArn(FanOutConfig.java:95)
          at software.amazon.kinesis.retrieval.fanout.FanOutConfig.retrievalFactory(FanOutConfig.java:85)
          at software.amazon.kinesis.retrieval.RetrievalConfig.retrievalFactory(RetrievalConfig.java:94)
          at software.amazon.kinesis.coordinator.Scheduler.buildConsumer(Scheduler.java:561)
          at software.amazon.kinesis.coordinator.Scheduler.createOrGetShardConsumer(Scheduler.java:552)
          at software.amazon.kinesis.coordinator.Scheduler.runProcessLoop(Scheduler.java:290)
          at software.amazon.kinesis.coordinator.Scheduler.run(Scheduler.java:222)
          at software.amazon.kinesis.multilang.MultiLangDaemon$MultiLangRunner.call(MultiLangDaemon.java:95)
          at software.amazon.kinesis.multilang.MultiLangDaemon$MultiLangRunner.call(MultiLangDaemon.java:86)
          at java.base/java.util.concurrent.FutureTask.run(FutureTask.java:264)
          at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128)
          at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628)
          at java.base/java.lang.Thread.run(Thread.java:829)
  2021-05-08 16:07:38,876 [multi-lang-daemon-0000] ERROR s.a.k.r.f.FanOutConsumerRegistration [NONE] - Status of StreamConsumer PythonKCLSample2, was not ACTIVE after all retries. Was instead CREATING.
  2021-05-08 16:07:38,876 [multi-lang-daemon-0000] ERROR s.a.kinesis.coordinator.Scheduler [NONE] - Worker.run caught exception, sleeping for 1000 milli seconds!
  java.lang.IllegalStateException: Status of StreamConsumer PythonKCLSample2, was not ACTIVE after all retries. Was instead CREATING.
          at software.amazon.kinesis.retrieval.fanout.FanOutConsumerRegistration.waitForActive(FanOutConsumerRegistration.java:162)
          at software.amazon.kinesis.retrieval.fanout.FanOutConsumerRegistration.getOrCreateStreamConsumerArn(FanOutConsumerRegistration.java:111)
          at software.amazon.kinesis.retrieval.fanout.FanOutConfig.getOrCreateConsumerArn(FanOutConfig.java:95)
          at software.amazon.kinesis.retrieval.fanout.FanOutConfig.retrievalFactory(FanOutConfig.java:85)
          at software.amazon.kinesis.retrieval.RetrievalConfig.retrievalFactory(RetrievalConfig.java:94)
          at software.amazon.kinesis.coordinator.Scheduler.buildConsumer(Scheduler.java:561)
          at software.amazon.kinesis.coordinator.Scheduler.createOrGetShardConsumer(Scheduler.java:552)
          at software.amazon.kinesis.coordinator.Scheduler.runProcessLoop(Scheduler.java:290)
          at software.amazon.kinesis.coordinator.Scheduler.run(Scheduler.java:222)
          at software.amazon.kinesis.multilang.MultiLangDaemon$MultiLangRunner.call(MultiLangDaemon.java:95)
          at software.amazon.kinesis.multilang.MultiLangDaemon$MultiLangRunner.call(MultiLangDaemon.java:86)
          at java.base/java.util.concurrent.FutureTask.run(FutureTask.java:264)
          at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128)
          at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628)
          at java.base/java.lang.Thread.run(Thread.java:829)
  2021-05-08 16:07:39,949 [multi-lang-daemon-0000] INFO  s.a.kinesis.coordinator.Scheduler [NONE] - Created new shardConsumer for : ShardInfo(shardId=shardId-000000000000, concurrencyToken=8ca6474a-e02f-4519-890c-d37adcdfd61b, parentShardIds=[], checkpoint={SequenceNumber: TRIM_HORIZON,SubsequenceNumber: 0})
  2021-05-08 16:07:39,952 [ShardRecordProcessor-0000] INFO  s.a.k.l.BlockOnParentShardTask [NONE] - No need to block on parents [] of shard shardId-000000000000
  2021-05-08 16:07:41,006 [multi-lang-daemon-0001] INFO  s.a.kinesis.multilang.LineReaderTask [NONE] - Starting: Reading STDERR for shardId-000000000000
  2021-05-08 16:07:41,007 [ShardRecordProcessor-0000] INFO  s.a.kinesis.multilang.MessageWriter [NONE] - Writing InitializeMessage to child process for shard shardId-000000000000
  2021-05-08 16:07:41,162 [multi-lang-daemon-0002] INFO  s.a.kinesis.multilang.MessageWriter [NONE] - Message size == 110 bytes for shard shardId-000000000000
  2021-05-08 16:07:41,166 [multi-lang-daemon-0003] INFO  s.a.kinesis.multilang.LineReaderTask [NONE] - Starting: Reading next message from STDIN for shardId-000000000000
  2021-05-08 16:07:41,500 [ShardRecordProcessor-0000] INFO  s.a.k.multilang.MultiLangProtocol [NONE] - Received response {"action":"status","responseFor":"initialize"} from subprocess while waiting for initialize while processing shard shardId-000000000000
  2021-05-08 16:07:43,150 [ShardRecordProcessor-0000] INFO  s.a.kinesis.multilang.MessageWriter [NONE] - Writing ProcessRecordsMessage to child process for shard shardId-000000000000
  2021-05-08 16:07:43,174 [multi-lang-daemon-0003] INFO  s.a.kinesis.multilang.MessageWriter [NONE] - Message size == 1101 bytes for shard shardId-000000000000
  2021-05-08 16:07:43,176 [multi-lang-daemon-0003] INFO  s.a.kinesis.multilang.LineReaderTask [NONE] - Starting: Reading next message from STDIN for shardId-000000000000
  2021-05-08 16:07:43,178 [ShardRecordProcessor-0000] INFO  s.a.k.multilang.MultiLangProtocol [NONE] - Received response {"action":"status","responseFor":"processRecords"} from subprocess while waiting for processRecords while processing shard shardId-000000000000


# Python内の処理を追えるようにデバッグ用ログを出力しているので、tailするといい（sample1のみ）
cd kcl
tail -f test.log
  （-----冒頭は割愛。以下は最終的なメッセージの出力結果-----）

  2021-05-08 16:11:22 DEBUG    -----start processing logic-----
  2021-05-08 16:11:22 DEBUG    Query: INSERT INTO target_tbl_1 (id, head, body, payload, create_timestamp, update_timestamp) VALUES (1, 'head_test', 'body_test', '{"age": 21, "Name": "satou", "kclFLG": 1}', '2021-05-08T16:11:22.116517Z', '2021-05-08T16:11:22.116517Z') ON CONFLICT (id) DO UPDATE SET id = EXCLUDED.id, head = EXCLUDED.head, body = EXCLUDED.body, payload = EXCLUDED.payload, create_timestamp = EXCLUDED.create_timestamp, update_timestamp = EXCLUDED.update_timestamp;
  2021-05-08 16:11:22 DEBUG    -----finish processing logic-----
  2021-05-08 16:12:13 DEBUG    -----start processing logic-----
  2021-05-08 16:12:13 DEBUG    Query: INSERT INTO target_tbl_1 (id, head, body, payload, create_timestamp, update_timestamp) VALUES (2, 'head_test', 'body_test', '{"age": 22, "Name": "suzuki", "kclFLG": 1}', '2021-05-08T16:12:13.540064Z', '2021-05-08T16:12:13.540064Z') ON CONFLICT (id) DO UPDATE SET id = EXCLUDED.id, head = EXCLUDED.head, body = EXCLUDED.body, payload = EXCLUDED.payload, create_timestamp = EXCLUDED.create_timestamp, update_timestamp = EXCLUDED.update_timestamp;
  2021-05-08 16:12:13 DEBUG    -----finish processing logic-----
  2021-05-08 16:12:13 DEBUG    -----start processing logic-----
  2021-05-08 16:12:13 DEBUG    Query: INSERT INTO target_tbl_1 (id, head, body, payload, create_timestamp, update_timestamp) VALUES (3, 'head_test', 'body_test', '{"age": 23, "Name": "saito", "kclFLG": 1}', '2021-05-08T16:12:13.556287Z', '2021-05-08T16:12:13.556287Z') ON CONFLICT (id) DO UPDATE SET id = EXCLUDED.id, head = EXCLUDED.head, body = EXCLUDED.body, payload = EXCLUDED.payload, create_timestamp = EXCLUDED.create_timestamp, update_timestamp = EXCLUDED.update_timestamp;
  2021-05-08 16:12:13 DEBUG    -----finish processing logic-----
  2021-05-08 16:12:13 DEBUG    -----start processing logic-----
  2021-05-08 16:12:13 DEBUG    Query: INSERT INTO target_tbl_1 (id, head, body, payload, create_timestamp, update_timestamp) VALUES (4, 'head_test', 'body_test', '{"age": 24, "Name": "yamada", "kclFLG": 1}', '2021-05-08T16:12:13.570291Z', '2021-05-08T16:12:13.570291Z') ON CONFLICT (id) DO UPDATE SET id = EXCLUDED.id, head = EXCLUDED.head, body = EXCLUDED.body, payload = EXCLUDED.payload, create_timestamp = EXCLUDED.create_timestamp, update_timestamp = EXCLUDED.update_timestamp;
  2021-05-08 16:12:13 DEBUG    -----finish processing logic-----
  2021-05-08 16:12:13 DEBUG    -----start processing logic-----
  2021-05-08 16:12:13 DEBUG    Query: INSERT INTO target_tbl_1 (id, head, body, payload, create_timestamp, update_timestamp) VALUES (5, 'head_test', 'body_test', '{"age": 25, "Name": "ito", "kclFLG": 1}', '2021-05-08T16:12:13.582134Z', '2021-05-08T16:12:13.582134Z') ON CONFLICT (id) DO UPDATE SET id = EXCLUDED.id, head = EXCLUDED.head, body = EXCLUDED.body, payload = EXCLUDED.payload, create_timestamp = EXCLUDED.create_timestamp, update_timestamp = EXCLUDED.update_timestamp;
  2021-05-08 16:12:13 DEBUG    -----finish processing logic-----
  2021-05-08 16:12:15 DEBUG    -----start processing logic-----
  2021-05-08 16:12:15 DEBUG    Query: INSERT INTO target_tbl_1 (id, head, body, payload, create_timestamp, update_timestamp) VALUES (6, 'head_test', 'body_test', '{"age": 26, "Name": "takahashi", "kclFLG": 1}', '2021-05-08T16:12:15.144689Z', '2021-05-08T16:12:15.144689Z') ON CONFLICT (id) DO UPDATE SET id = EXCLUDED.id, head = EXCLUDED.head, body = EXCLUDED.body, payload = EXCLUDED.payload, create_timestamp = EXCLUDED.create_timestamp, update_timestamp = EXCLUDED.update_timestamp;
  2021-05-08 16:12:15 DEBUG    -----finish processing logic-----
  2021-05-08 16:12:42 DEBUG    -----start processing logic-----
  2021-05-08 16:12:42 DEBUG    Query: INSERT INTO target_tbl_1 (id, head, body, payload, create_timestamp, update_timestamp) VALUES (1, 'head_test', 'updated_body_test', '{"age": 21, "Name": "satou", "kclFLG": 1}', '2021-05-08T16:11:22.116517Z', '2021-05-08T16:12:42.207762Z') ON CONFLICT (id) DO UPDATE SET id = EXCLUDED.id, head = EXCLUDED.head, body = EXCLUDED.body, payload = EXCLUDED.payload, create_timestamp = EXCLUDED.create_timestamp, update_timestamp = EXCLUDED.update_timestamp;
  2021-05-08 16:12:42 DEBUG    -----finish processing logic-----
  2021-05-08 16:15:38 DEBUG    -----start processing logic-----
  2021-05-08 16:15:38 DEBUG    Query: DELETE FROM target_tbl_1 WHERE id = 2
  2021-05-08 16:15:38 DEBUG    -----finish processing logic-----
  2021-05-08 16:16:19 DEBUG    -----start processing logic-----
  2021-05-08 16:16:19 DEBUG    Query: INSERT INTO target_tbl_1 (id, head, body, payload, create_timestamp, update_timestamp) VALUES (3, 'head_test', 'batch_updated_body_test', '{"age": 23, "Name": "saito", "kclFLG": 1}', '2021-05-08T16:12:13.556287Z', '2021-05-08T16:16:19.133351Z') ON CONFLICT (id) DO UPDATE SET id = EXCLUDED.id, head = EXCLUDED.head, body = EXCLUDED.body, payload = EXCLUDED.payload, create_timestamp = EXCLUDED.create_timestamp, update_timestamp = EXCLUDED.update_timestamp;
  2021-05-08 16:16:19 DEBUG    -----finish processing logic-----
  2021-05-08 16:16:19 DEBUG    -----start processing logic-----
  2021-05-08 16:16:19 DEBUG    Query: INSERT INTO target_tbl_1 (id, head, body, payload, create_timestamp, update_timestamp) VALUES (4, 'head_test', 'batch_updated_body_test', '{"age": 24, "Name": "yamada", "kclFLG": 1}', '2021-05-08T16:12:13.570291Z', '2021-05-08T16:16:19.133351Z') ON CONFLICT (id) DO UPDATE SET id = EXCLUDED.id, head = EXCLUDED.head, body = EXCLUDED.body, payload = EXCLUDED.payload, create_timestamp = EXCLUDED.create_timestamp, update_timestamp = EXCLUDED.update_timestamp;
  2021-05-08 16:16:19 DEBUG    -----finish processing logic-----
  2021-05-08 16:16:19 DEBUG    -----start processing logic-----
  2021-05-08 16:16:19 DEBUG    Query: INSERT INTO target_tbl_1 (id, head, body, payload, create_timestamp, update_timestamp) VALUES (5, 'head_test', 'batch_updated_body_test', '{"age": 25, "Name": "ito", "kclFLG": 1}', '2021-05-08T16:12:13.582134Z', '2021-05-08T16:16:19.133351Z') ON CONFLICT (id) DO UPDATE SET id = EXCLUDED.id, head = EXCLUDED.head, body = EXCLUDED.body, payload = EXCLUDED.payload, create_timestamp = EXCLUDED.create_timestamp, update_timestamp = EXCLUDED.update_timestamp;
  2021-05-08 16:16:19 DEBUG    -----finish processing logic-----
  2021-05-08 16:16:19 DEBUG    -----start processing logic-----
  2021-05-08 16:16:19 DEBUG    Query: INSERT INTO target_tbl_1 (id, head, body, payload, create_timestamp, update_timestamp) VALUES (6, 'head_test', 'batch_updated_body_test', '{"age": 26, "Name": "takahashi", "kclFLG": 1}', '2021-05-08T16:12:15.144689Z', '2021-05-08T16:16:19.133351Z') ON CONFLICT (id) DO UPDATE SET id = EXCLUDED.id, head = EXCLUDED.head, body = EXCLUDED.body, payload = EXCLUDED.payload, create_timestamp = EXCLUDED.create_timestamp, update_timestamp = EXCLUDED.update_timestamp;
  2021-05-08 16:16:19 DEBUG    -----finish processing logic-----
  2021-05-08 16:17:17 DEBUG    -----start processing logic-----
  2021-05-08 16:17:17 DEBUG    Query: DELETE FROM target_tbl_1 WHERE id = 3
  2021-05-08 16:17:17 DEBUG    -----finish processing logic-----
  2021-05-08 16:17:17 DEBUG    -----start processing logic-----
  2021-05-08 16:17:17 DEBUG    Query: DELETE FROM target_tbl_1 WHERE id = 4
  2021-05-08 16:17:17 DEBUG    -----finish processing logic-----
  2021-05-08 16:17:17 DEBUG    -----start processing logic-----
  2021-05-08 16:17:17 DEBUG    Query: DELETE FROM target_tbl_1 WHERE id = 5
  2021-05-08 16:17:17 DEBUG    -----finish processing logic-----
  2021-05-08 16:17:17 DEBUG    -----start processing logic-----
  2021-05-08 16:17:17 DEBUG    Query: DELETE FROM target_tbl_1 WHERE id = 6
  2021-05-08 16:17:17 DEBUG    -----finish processing logic-----



#-------------------------------------------
# psqlで接続してinsertやupdate、deleteを実施
#-------------------------------------------

# Set your Aurora cloudformation Stack Name below
export AURORA_CFN_STACK_NAME=dms-kinesis-kcl-aurora
export PGHOST=`aws cloudformation describe-stacks --stack-name ${AURORA_CFN_STACK_NAME} --query Stacks[*].Outputs | jq .[0] | jq 'map(select( .OutputKey == "auroraClusterEndpoint" ))' | jq -r .[0].OutputValue`
# Set your Aurora master user name
export PGUSER=postgres
# Set your SSM Parameter Name (Aurora Master User Password)
export MASTER_PASSWD=/dms-kinesis-kcl/aurora-admin-password
export PGPASSWORD=`aws ssm get-parameter --name ${MASTER_PASSWD} --with-decryption --query Parameter.Value --output text`
# Set Database name and Port number below
export PGDATABASE=streaming_db
export PGPORT=5432


psql

\pset x auto
\pset pager off
\conninfo

--#--------------------------------------
--# INSERT some test data
--#--------------------------------------
INSERT INTO source_tbl (head, body, payload) VALUES ('head_test', 'body_test', '{"Name": "satou", "age": 21}');
  INSERT 0 1
INSERT INTO source_tbl (head, body, payload) VALUES ('head_test', 'body_test', '{"Name": "suzuki", "age": 22}');
  INSERT 0 1
INSERT INTO source_tbl (head, body, payload) VALUES ('head_test', 'body_test', '{"Name": "saito", "age": 23}');
  INSERT 0 1
INSERT INTO source_tbl (head, body, payload) VALUES ('head_test', 'body_test', '{"Name": "yamada", "age": 24}');
  INSERT 0 1
INSERT INTO source_tbl (head, body, payload) VALUES ('head_test', 'body_test', '{"Name": "ito", "age": 25}');
  INSERT 0 1
INSERT INTO source_tbl (head, body, payload) VALUES ('head_test', 'body_test', '{"Name": "takahashi", "age": 26}');
  INSERT 0 1

--# Check Table
SELECT * FROM source_tbl;

SELECT * FROM target_tbl_1;
  id |   head    |   body    |                    payload                    |      create_timestamp      |      update_timestamp
  ----+-----------+-----------+-----------------------------------------------+----------------------------+----------------------------
    1 | head_test | body_test | {"age": 21, "Name": "satou", "kclFLG": 1}     | 2021-05-08 16:11:22.116517 | 2021-05-08 16:11:22.116517
    2 | head_test | body_test | {"age": 22, "Name": "suzuki", "kclFLG": 1}    | 2021-05-08 16:12:13.540064 | 2021-05-08 16:12:13.540064
    3 | head_test | body_test | {"age": 23, "Name": "saito", "kclFLG": 1}     | 2021-05-08 16:12:13.556287 | 2021-05-08 16:12:13.556287
    4 | head_test | body_test | {"age": 24, "Name": "yamada", "kclFLG": 1}    | 2021-05-08 16:12:13.570291 | 2021-05-08 16:12:13.570291
    5 | head_test | body_test | {"age": 25, "Name": "ito", "kclFLG": 1}       | 2021-05-08 16:12:13.582134 | 2021-05-08 16:12:13.582134
    6 | head_test | body_test | {"age": 26, "Name": "takahashi", "kclFLG": 1} | 2021-05-08 16:12:15.144689 | 2021-05-08 16:12:15.144689
  (6 rows)
SELECT * FROM target_tbl_2;
  id |   head    |   body    |                    payload                    |      create_timestamp      |      update_timestamp
  ----+-----------+-----------+-----------------------------------------------+----------------------------+----------------------------
    1 | head_test | body_test | {"age": 21, "Name": "satou", "kclFLG": 2}     | 2021-05-08 16:11:22.116517 | 2021-05-08 16:11:22.116517
    2 | head_test | body_test | {"age": 22, "Name": "suzuki", "kclFLG": 2}    | 2021-05-08 16:12:13.540064 | 2021-05-08 16:12:13.540064
    3 | head_test | body_test | {"age": 23, "Name": "saito", "kclFLG": 2}     | 2021-05-08 16:12:13.556287 | 2021-05-08 16:12:13.556287
    4 | head_test | body_test | {"age": 24, "Name": "yamada", "kclFLG": 2}    | 2021-05-08 16:12:13.570291 | 2021-05-08 16:12:13.570291
    5 | head_test | body_test | {"age": 25, "Name": "ito", "kclFLG": 2}       | 2021-05-08 16:12:13.582134 | 2021-05-08 16:12:13.582134
    6 | head_test | body_test | {"age": 26, "Name": "takahashi", "kclFLG": 2} | 2021-05-08 16:12:15.144689 | 2021-05-08 16:12:15.144689
  (6 rows)

--#--------------------------------------
--# UPDATE some test data
--#--------------------------------------
UPDATE source_tbl SET body = 'updated_body_test', update_timestamp = current_timestamp WHERE id = 1;
  UPDATE 1

--# Check Table
SELECT * FROM source_tbl;
  id |   head    |       body        |             payload              |      create_timestamp      |      update_timestamp
  ----+-----------+-------------------+----------------------------------+----------------------------+----------------------------
    2 | head_test | body_test         | {"age": 22, "Name": "suzuki"}    | 2021-05-08 16:12:13.540064 | 2021-05-08 16:12:13.540064
    3 | head_test | body_test         | {"age": 23, "Name": "saito"}     | 2021-05-08 16:12:13.556287 | 2021-05-08 16:12:13.556287
    4 | head_test | body_test         | {"age": 24, "Name": "yamada"}    | 2021-05-08 16:12:13.570291 | 2021-05-08 16:12:13.570291
    5 | head_test | body_test         | {"age": 25, "Name": "ito"}       | 2021-05-08 16:12:13.582134 | 2021-05-08 16:12:13.582134
    6 | head_test | body_test         | {"age": 26, "Name": "takahashi"} | 2021-05-08 16:12:15.144689 | 2021-05-08 16:12:15.144689
    1 | head_test | updated_body_test | {"age": 21, "Name": "satou"}     | 2021-05-08 16:11:22.116517 | 2021-05-08 16:12:42.207762
  (6 rows)

SELECT * FROM target_tbl_1;
  id |   head    |       body        |                    payload                    |      create_timestamp      |      update_timestamp
  ----+-----------+-------------------+-----------------------------------------------+----------------------------+----------------------------
    2 | head_test | body_test         | {"age": 22, "Name": "suzuki", "kclFLG": 1}    | 2021-05-08 16:12:13.540064 | 2021-05-08 16:12:13.540064
    3 | head_test | body_test         | {"age": 23, "Name": "saito", "kclFLG": 1}     | 2021-05-08 16:12:13.556287 | 2021-05-08 16:12:13.556287
    4 | head_test | body_test         | {"age": 24, "Name": "yamada", "kclFLG": 1}    | 2021-05-08 16:12:13.570291 | 2021-05-08 16:12:13.570291
    5 | head_test | body_test         | {"age": 25, "Name": "ito", "kclFLG": 1}       | 2021-05-08 16:12:13.582134 | 2021-05-08 16:12:13.582134
    6 | head_test | body_test         | {"age": 26, "Name": "takahashi", "kclFLG": 1} | 2021-05-08 16:12:15.144689 | 2021-05-08 16:12:15.144689
    1 | head_test | updated_body_test | {"age": 21, "Name": "satou", "kclFLG": 1}     | 2021-05-08 16:11:22.116517 | 2021-05-08 16:12:42.207762
  (6 rows)

SELECT * FROM target_tbl_2;
  id |   head     |       body        |                    payload                    |      create_timestamp      |      update_timestamp
  ----+-----------+-------------------+-----------------------------------------------+----------------------------+----------------------------
    2 | head_test | body_test         | {"age": 22, "Name": "suzuki", "kclFLG": 2}    | 2021-05-08 16:12:13.540064 | 2021-05-08 16:12:13.540064
    3 | head_test | body_test         | {"age": 23, "Name": "saito", "kclFLG": 2}     | 2021-05-08 16:12:13.556287 | 2021-05-08 16:12:13.556287
    4 | head_test | body_test         | {"age": 24, "Name": "yamada", "kclFLG": 2}    | 2021-05-08 16:12:13.570291 | 2021-05-08 16:12:13.570291
    5 | head_test | body_test         | {"age": 25, "Name": "ito", "kclFLG": 2}       | 2021-05-08 16:12:13.582134 | 2021-05-08 16:12:13.582134
    6 | head_test | body_test         | {"age": 26, "Name": "takahashi", "kclFLG": 2} | 2021-05-08 16:12:15.144689 | 2021-05-08 16:12:15.144689
    1 | head_test | updated_body_test | {"age": 21, "Name": "satou", "kclFLG": 2}     | 2021-05-08 16:11:22.116517 | 2021-05-08 16:12:42.207762
  (6 rows)


--#--------------------------------------
--# DELETE some test data
--#--------------------------------------
DELETE FROM source_tbl WHERE id = 2;
  DELETE 1

--# Check Table
SELECT * FROM source_tbl;
  id |   head    |       body        |             payload              |      create_timestamp      |      update_timestamp
  ----+-----------+-------------------+----------------------------------+----------------------------+----------------------------
    3 | head_test | body_test         | {"age": 23, "Name": "saito"}     | 2021-05-08 16:12:13.556287 | 2021-05-08 16:12:13.556287
    4 | head_test | body_test         | {"age": 24, "Name": "yamada"}    | 2021-05-08 16:12:13.570291 | 2021-05-08 16:12:13.570291
    5 | head_test | body_test         | {"age": 25, "Name": "ito"}       | 2021-05-08 16:12:13.582134 | 2021-05-08 16:12:13.582134
    6 | head_test | body_test         | {"age": 26, "Name": "takahashi"} | 2021-05-08 16:12:15.144689 | 2021-05-08 16:12:15.144689
    1 | head_test | updated_body_test | {"age": 21, "Name": "satou"}     | 2021-05-08 16:11:22.116517 | 2021-05-08 16:12:42.207762
  (5 rows)


SELECT * FROM target_tbl_1;
  id |   head    |       body        |                    payload                    |      create_timestamp      |      update_timestamp
  ----+-----------+-------------------+-----------------------------------------------+----------------------------+----------------------------
    3 | head_test | body_test         | {"age": 23, "Name": "saito", "kclFLG": 1}     | 2021-05-08 16:12:13.556287 | 2021-05-08 16:12:13.556287
    4 | head_test | body_test         | {"age": 24, "Name": "yamada", "kclFLG": 1}    | 2021-05-08 16:12:13.570291 | 2021-05-08 16:12:13.570291
    5 | head_test | body_test         | {"age": 25, "Name": "ito", "kclFLG": 1}       | 2021-05-08 16:12:13.582134 | 2021-05-08 16:12:13.582134
    6 | head_test | body_test         | {"age": 26, "Name": "takahashi", "kclFLG": 1} | 2021-05-08 16:12:15.144689 | 2021-05-08 16:12:15.144689
    1 | head_test | updated_body_test | {"age": 21, "Name": "satou", "kclFLG": 1}     | 2021-05-08 16:11:22.116517 | 2021-05-08 16:12:42.207762
  (5 rows)

SELECT * FROM target_tbl_2;
  id |   head    |       body        |                    payload                    |      create_timestamp      |      update_timestamp
  ----+-----------+-------------------+-----------------------------------------------+----------------------------+----------------------------
    3 | head_test | body_test         | {"age": 23, "Name": "saito", "kclFLG": 2}     | 2021-05-08 16:12:13.556287 | 2021-05-08 16:12:13.556287
    4 | head_test | body_test         | {"age": 24, "Name": "yamada", "kclFLG": 2}    | 2021-05-08 16:12:13.570291 | 2021-05-08 16:12:13.570291
    5 | head_test | body_test         | {"age": 25, "Name": "ito", "kclFLG": 2}       | 2021-05-08 16:12:13.582134 | 2021-05-08 16:12:13.582134
    6 | head_test | body_test         | {"age": 26, "Name": "takahashi", "kclFLG": 2} | 2021-05-08 16:12:15.144689 | 2021-05-08 16:12:15.144689
    1 | head_test | updated_body_test | {"age": 21, "Name": "satou", "kclFLG": 2}     | 2021-05-08 16:11:22.116517 | 2021-05-08 16:12:42.207762
  (5 rows)



--#--------------------------------------
--# Batch UPDATE data
--#--------------------------------------
UPDATE source_tbl SET body = 'batch_updated_body_test', update_timestamp = current_timestamp WHERE body = 'body_test';
  UPDATE 4


--# Check Table
SELECT * FROM source_tbl;
  id |   head    |          body           |             payload              |      create_timestamp      |      update_timestamp
  ----+-----------+-------------------------+----------------------------------+----------------------------+----------------------------
    1 | head_test | updated_body_test       | {"age": 21, "Name": "satou"}     | 2021-05-08 16:11:22.116517 | 2021-05-08 16:12:42.207762
    3 | head_test | batch_updated_body_test | {"age": 23, "Name": "saito"}     | 2021-05-08 16:12:13.556287 | 2021-05-08 16:16:19.133351
    4 | head_test | batch_updated_body_test | {"age": 24, "Name": "yamada"}    | 2021-05-08 16:12:13.570291 | 2021-05-08 16:16:19.133351
    5 | head_test | batch_updated_body_test | {"age": 25, "Name": "ito"}       | 2021-05-08 16:12:13.582134 | 2021-05-08 16:16:19.133351
    6 | head_test | batch_updated_body_test | {"age": 26, "Name": "takahashi"} | 2021-05-08 16:12:15.144689 | 2021-05-08 16:16:19.133351
  (5 rows)

SELECT * FROM target_tbl_1;
  id |   head    |          body           |                    payload                    |      create_timestamp      |      update_timestamp
  ----+-----------+-------------------------+-----------------------------------------------+----------------------------+----------------------------
    1 | head_test | updated_body_test       | {"age": 21, "Name": "satou", "kclFLG": 1}     | 2021-05-08 16:11:22.116517 | 2021-05-08 16:12:42.207762
    3 | head_test | batch_updated_body_test | {"age": 23, "Name": "saito", "kclFLG": 1}     | 2021-05-08 16:12:13.556287 | 2021-05-08 16:16:19.133351
    4 | head_test | batch_updated_body_test | {"age": 24, "Name": "yamada", "kclFLG": 1}    | 2021-05-08 16:12:13.570291 | 2021-05-08 16:16:19.133351
    5 | head_test | batch_updated_body_test | {"age": 25, "Name": "ito", "kclFLG": 1}       | 2021-05-08 16:12:13.582134 | 2021-05-08 16:16:19.133351
    6 | head_test | batch_updated_body_test | {"age": 26, "Name": "takahashi", "kclFLG": 1} | 2021-05-08 16:12:15.144689 | 2021-05-08 16:16:19.133351
  (5 rows)

SELECT * FROM target_tbl_2;
  id |   head    |          body           |                    payload                    |      create_timestamp      |      update_timestamp
  ----+-----------+-------------------------+-----------------------------------------------+----------------------------+----------------------------
    1 | head_test | updated_body_test       | {"age": 21, "Name": "satou", "kclFLG": 2}     | 2021-05-08 16:11:22.116517 | 2021-05-08 16:12:42.207762
    3 | head_test | batch_updated_body_test | {"age": 23, "Name": "saito", "kclFLG": 2}     | 2021-05-08 16:12:13.556287 | 2021-05-08 16:16:19.133351
    4 | head_test | batch_updated_body_test | {"age": 24, "Name": "yamada", "kclFLG": 2}    | 2021-05-08 16:12:13.570291 | 2021-05-08 16:16:19.133351
    5 | head_test | batch_updated_body_test | {"age": 25, "Name": "ito", "kclFLG": 2}       | 2021-05-08 16:12:13.582134 | 2021-05-08 16:16:19.133351
    6 | head_test | batch_updated_body_test | {"age": 26, "Name": "takahashi", "kclFLG": 2} | 2021-05-08 16:12:15.144689 | 2021-05-08 16:16:19.133351
  (5 rows)



--#--------------------------------------
--# batch UPDATE and DELETE
--#--------------------------------------
DELETE FROM source_tbl WHERE id > 2;
  DELETE 4

--# Check Table
SELECT * FROM source_tbl;
  id |   head    |       body        |           payload            |      create_timestamp      |      update_timestamp
  ----+-----------+-------------------+------------------------------+----------------------------+----------------------------
    1 | head_test | updated_body_test | {"age": 21, "Name": "satou"} | 2021-05-08 16:11:22.116517 | 2021-05-08 16:12:42.207762
  (1 row)


SELECT * FROM target_tbl_1;
  id |   head    |       body        |                  payload                  |      create_timestamp      |      update_timestamp
  ----+-----------+-------------------+-------------------------------------------+----------------------------+----------------------------
    1 | head_test | updated_body_test | {"age": 21, "Name": "satou", "kclFLG": 1} | 2021-05-08 16:11:22.116517 | 2021-05-08 16:12:42.207762
  (1 row)

SELECT * FROM target_tbl_2;
  id |   head    |       body        |                  payload                  |      create_timestamp      |      update_timestamp
  ----+-----------+-------------------+-------------------------------------------+----------------------------+----------------------------
    1 | head_test | updated_body_test | {"age": 21, "Name": "satou", "kclFLG": 2} | 2021-05-08 16:11:22.116517 | 2021-05-08 16:12:42.207762
  (1 row)


EOF