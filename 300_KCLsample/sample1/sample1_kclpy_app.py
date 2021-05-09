#!/usr/bin/env python

# Copyright 2014-2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Amazon Software License (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
#
# http://aws.amazon.com/asl/
#
# or in the "license" file accompanying this file. This file is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied. See the License for the specific language governing
# permissions and limitations under the License.

from __future__ import print_function

import sys
import time

from amazon_kclpy import kcl
from amazon_kclpy.v3 import processor

# PostgreSQL client library and other standard library for processing data
import psycopg2
import base64
import json
import os
import boto3

# REGION (use boto3. Specify SSM Parameter store)
REGION='ap-northeast-1'

# for debug
import logging

class RecordProcessor(processor.RecordProcessorBase):
    """
    A RecordProcessor processes data from a shard in a stream. Its methods will be called with this pattern:
    * initialize will be called once
    * process_records will be called zero or more times
    * shutdown will be called if this MultiLangDaemon instance loses the lease to this shard, or the shard ends due
        a scaling change.
    """
    def __init__(self):
        self._SLEEP_SECONDS = 5
        self._CHECKPOINT_RETRIES = 5
        self._CHECKPOINT_FREQ_SECONDS = 60
        self._largest_seq = (None, None)
        self._largest_sub_seq = None
        self._last_checkpoint_time = None
        
        # for debug
        logging.basicConfig(filename='test.log',
        format='%(asctime)s %(levelname)-8s %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S',
        level=logging.DEBUG)
        
        # DB connection parameters
        self.pghost = 'dms-kinesis-kcl-aurora-posgresql.cluster-coqptnsxlyvd.ap-northeast-1.rds.amazonaws.com'
        self.pgport = '5432'
        self.pgdbname = 'streaming_db'
        self.pguser = 'postgres'
        self.pgpassword = self.get_parameters('/dms-kinesis-kcl/aurora-admin-password')

    def log(self, message):
        sys.stderr.write(message)

    def initialize(self, initialize_input):
        """
        Called once by a KCLProcess before any calls to process_records
        :param amazon_kclpy.messages.InitializeInput initialize_input: Information about the lease that this record
            processor has been assigned.
        """
        self._largest_seq = (None, None)
        self._last_checkpoint_time = time.time()

    def checkpoint(self, checkpointer, sequence_number=None, sub_sequence_number=None):
        """
        Checkpoints with retries on retryable exceptions.
        :param amazon_kclpy.kcl.Checkpointer checkpointer: the checkpointer provided to either process_records
            or shutdown
        :param str or None sequence_number: the sequence number to checkpoint at.
        :param int or None sub_sequence_number: the sub sequence number to checkpoint at.
        """
        for n in range(0, self._CHECKPOINT_RETRIES):
            try:
                checkpointer.checkpoint(sequence_number, sub_sequence_number)
                return
            except kcl.CheckpointError as e:
                if 'ShutdownException' == e.value:
                    #
                    # A ShutdownException indicates that this record processor should be shutdown. This is due to
                    # some failover event, e.g. another MultiLangDaemon has taken the lease for this shard.
                    #
                    print('Encountered shutdown exception, skipping checkpoint')
                    return
                elif 'ThrottlingException' == e.value:
                    #
                    # A ThrottlingException indicates that one of our dependencies is is over burdened, e.g. too many
                    # dynamo writes. We will sleep temporarily to let it recover.
                    #
                    if self._CHECKPOINT_RETRIES - 1 == n:
                        sys.stderr.write('Failed to checkpoint after {n} attempts, giving up.\n'.format(n=n))
                        return
                    else:
                        print('Was throttled while checkpointing, will attempt again in {s} seconds'
                              .format(s=self._SLEEP_SECONDS))
                elif 'InvalidStateException' == e.value:
                    sys.stderr.write('MultiLangDaemon reported an invalid state while checkpointing.\n')
                else:  # Some other error
                    sys.stderr.write('Encountered an error while checkpointing, error was {e}.\n'.format(e=e))
            time.sleep(self._SLEEP_SECONDS)

    def process_record(self, data, partition_key, sequence_number, sub_sequence_number):
        """
        Called for each record that is passed to process_records.
        :param str data: The blob of data that was contained in the record.
        :param str partition_key: The key associated with this recod.
        :param int sequence_number: The sequence number associated with this record.
        :param int sub_sequence_number: the sub sequence number associated with this record.
        """
        # process logic
        if partition_key == 'public.source_tbl' :
            logging.debug('-----start processing logic-----')
            self.process_logic(data)
        
        self.log("Record (Partition Key: {pk}, Sequence Number: {seq}, Subsequence Number: {sseq}, Data Size: {ds}"
                 .format(pk=partition_key, seq=sequence_number, sseq=sub_sequence_number, ds=len(data)))


    def should_update_sequence(self, sequence_number, sub_sequence_number):
        """
        Determines whether a new larger sequence number is available
        :param int sequence_number: the sequence number from the current record
        :param int sub_sequence_number: the sub sequence number from the current record
        :return boolean: true if the largest sequence should be updated, false otherwise
        """
        return self._largest_seq == (None, None) or sequence_number > self._largest_seq[0] or \
            (sequence_number == self._largest_seq[0] and sub_sequence_number > self._largest_seq[1])

    def process_records(self, process_records_input):
        """
        Called by a KCLProcess with a list of records to be processed and a checkpointer which accepts sequence numbers
        from the records to indicate where in the stream to checkpoint.
        :param amazon_kclpy.messages.ProcessRecordsInput process_records_input: the records, and metadata about the
            records.
        """
        try:
            for record in process_records_input.records:
                data = record.binary_data
                seq = int(record.sequence_number)
                sub_seq = record.sub_sequence_number
                key = record.partition_key
                self.process_record(data, key, seq, sub_seq)
                if self.should_update_sequence(seq, sub_seq):
                    self._largest_seq = (seq, sub_seq)

            #
            # Checkpoints every self._CHECKPOINT_FREQ_SECONDS seconds
            #
            if time.time() - self._last_checkpoint_time > self._CHECKPOINT_FREQ_SECONDS:
                self.checkpoint(process_records_input.checkpointer, str(self._largest_seq[0]), self._largest_seq[1])
                self._last_checkpoint_time = time.time()

        except Exception as e:
            self.log("Encountered an exception while processing records. Exception was {e}\n".format(e=e))

    def lease_lost(self, lease_lost_input):
        self.log("Lease has been lost")

    def shard_ended(self, shard_ended_input):
        self.log("Shard has ended checkpointing")
        shard_ended_input.checkpointer.checkpoint()

    def shutdown_requested(self, shutdown_requested_input):
        self.log("Shutdown has been requested, checkpointing.")
        shutdown_requested_input.checkpointer.checkpoint()

    #------------------------------------
    # Process_logic
    #   process data logic
    #------------------------------------
    def process_logic(self, row_data):
        """
        process data and upsert to target table
        :param row_data (str): base64 encoded row data
        """
        json_row_data = json.loads(row_data)

        # transform
        json_data = self.transform_logic(json_row_data)

        # column list (INSERT INTO <table> (<column list>) VALUES (<values>))
        column_str = ''
        for i, column in enumerate(json_data['data'].keys()):
            if i == 0 :
                column_str = column
            else:
                column_str = "{}, {}".format(column_str, column)
        
        # values (INSERT INTO <table> (<column list>) VALUES (<values>))
        processed_data = ''
        for i, value in enumerate(json_data['data'].values()):
            if i == 0 :
                if type(value) is int or type(value) is float:
                    processed_data = str(value)
                else:
                    processed_data = "'{}'".format(value)
            else:
                if type(value) is int or type(value) is float:
                    processed_data = "{}, {}".format(processed_data, value)
                else:
                    processed_data = "{}, '{}'".format(processed_data, value)    
    
        # primary key (in query string)
        pk_column = "id"
        
        # update string (INSERT ... ON CONFLICT (pk) DO UPDATE SET <update string>)
        update_str = ''
        for i, column in enumerate(json_data['data']):
            if i == 0:
                update_str = "{0} = EXCLUDED.{0}".format(column)
            else:
                update_str = "{0}, {1} = EXCLUDED.{1}".format(update_str, column)
        
        # Query String
        if json_data['metadata']['operation'] == 'insert' or json_data['metadata']['operation'] == 'update' :
            query = "INSERT INTO target_tbl_1 ({0}) VALUES ({1}) ON CONFLICT ({2}) DO UPDATE SET {3};".format(column_str, processed_data, pk_column, update_str)
        elif json_data['metadata']['operation'] == 'delete' and len(json_data['data']) == 1 :
            query = "DELETE FROM target_tbl_1 WHERE {0} = {1}".format(column_str, processed_data)
        else:
            query = ''
        
        # for debug
        logging.debug('Query: %s', query)
        
        # Execution query
        with psycopg2.connect(host = self.pghost, port = self.pgport, dbname = self.pgdbname, user = self.pguser, password = self.pgpassword) as conn:
            with conn.cursor() as cursor:
                try:
                    cursor.execute(query)
                except psycopg2.Error as e:
                    logging.debug(e)
        
        # for debug
        logging.debug('-----finish processing logic-----')

    #------------------------------------
    # Transform_logic
    #   Transform data logic
    #------------------------------------
    def transform_logic(self, row_dict):
        """
        transform logic here
        :param row_dict (dict): prased json_data
        """
        # check weather "payload" column is contained
        if 'payload' in row_dict['data']:
            # add new flag data to "payload"
            update_data = {"kclFLG": 1}
            
            update_json = json.loads(row_dict['data']['payload'])
            update_json.update(update_data)
            update_str = json.dumps(update_json)
            row_dict['data']['payload'] = update_str
        
        return row_dict

    #------------------------------------
    # Function for get_parameters
    #------------------------------------
    def get_parameters(self, param_key):
        ssm = boto3.client('ssm', region_name=REGION)
        response = ssm.get_parameters(
            Names=[
                param_key,
            ],
            WithDecryption=True
        )
        return response['Parameters'][0]['Value']

if __name__ == "__main__":
    kcl_process = kcl.KCLProcess(RecordProcessor())
    kcl_process.run()
