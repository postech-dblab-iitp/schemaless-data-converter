#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pathlib import Path
import utils
import sys
import yaml

def generateUnionQuery(configuration_yaml, schema_yaml):
    # Get the table name
    target_table_name = configuration_yaml['table_name']

    # Geneate a union query for the table
    # Make empty string
    union_query = ''
    # Append '('
    union_query += '('
    # Iterate over the partitions
    partitions = configuration_yaml['partitions']
    for i, partition in enumerate(partitions):
        # Get schema columns
        schema_columns = schema_yaml['columns']
        # Get columns not removed
        columns_wo_removing = utils.getSchemaColumnsWithoutRemovedColumns(schema_columns, configuration_yaml[partition])
        # Append '(SELECT'
        union_query += '(SELECT '
        # Iterate over the schema column
        for j, schema_column in enumerate(schema_columns):
            # Check if the column is removed.
            if schema_column not in columns_wo_removing:  
                # If so, append ‘NULL as <column>’
                union_query += ('NULL as ' + schema_column)
            else:
                union_query += schema_column
            # Append comma is not the last column
            if j < len(schema_columns) - 1:
                union_query += ', '
        # Append ‘FROM <partition table name>’
        partition_table_name = utils.getPartitionTableBasedName(target_table_name, partition)
        union_query += (' FROM ' + partition_table_name)
        # If not the last partition, append ‘) \n UNION \n’
        if i < len(partitions) - 1:
            union_query += ') \n UNION ALL \n'
        # Else, append ‘) \
        else:
            union_query += ')'
    # Append 'as <table name>'
    union_query += (') as ' + target_table_name)
    return union_query

def exportQuery(output_queries_path, query_file_name, query):
    query_file_path = os.path.join(output_queries_path, query_file_name + '.sql')
    with open(query_file_path, 'w') as query_file:
        query_file.write(query)


configuration_file_path = sys.argv[1]

# Get configuration file
with open(configuration_file_path, "r") as configuration_file:
    configuration_yaml = yaml.load(configuration_file)
    schema_file_path = configuration_yaml['schema_file']
    table_name = configuration_yaml['table_name']
    with open(schema_file_path, "r") as schema_file:
        schema_yaml = yaml.load(schema_file)
        union_query = generateUnionQuery(configuration_yaml, schema_yaml)
        exportQuery('generated-queries/union-all/', table_name, union_query)
        
        