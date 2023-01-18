# -*- coding: utf-8 -*-

import os
from pathlib import Path
import utils

def modifyExportAllQueries(configuration_yaml, schema_yaml, queries_path, output_queries_path):
    # Get queries in the path and iterate over the queries
    for filename in os.listdir(queries_path):
        filepath = os.path.join(queries_path, filename)
        if os.path.isfile(filepath):
            # Call modify
            with open(filepath, 'r') as query_file:
                query = query_file.read()
                modified_query = modifyQuery(query, configuration_yaml, schema_yaml)
            # Export query
            exportQuery(output_queries_path, Path(filepath).stem, modified_query)
    return

def modifyQuery(query, configuration_yaml, schema_yaml):
    # Get the table name
    target_table_name = configuration_yaml['table_name']
    
    # Check if the query contains the table name. If not, return the original query.
    if target_table_name not in query: return query

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
        # Get type converted columns
        columns_type_converted = utils.getTypeConversionColumns(configuration_yaml[partition])
        # Append '(SELECT'
        union_query += '(SELECT '
        # Iterate over the schema column
        for j, schema_column in enumerate(schema_columns):
            # Check if the column is removed.
            if schema_column not in columns_wo_removing:  
                # If so, append ‘NULL as <column>’
                union_query += ('NULL as ' + schema_column)
            else:
                # Check if the column is type converted
                if schema_column in columns_type_converted:
                    # If so, append ‘cast(<column> as <type specified in the schema>)
                    column_type = schema_yaml[schema_column]
                    union_query += ('cast(' + schema_column + ' as ' + column_type + ')')
                else:
                    # Else, append ‘<column>’
                    union_query += schema_column
            # Append comma is not the last column
            if j < len(schema_columns) - 1:
                union_query += ', '
        # Append ‘FROM <partition table name>’
        partition_table_name = utils.getPartitionFileBaseName(configuration_yaml, partition)
        union_query += (' FROM ' + partition_table_name)
        # If not the last partition, append ‘) \n UNION \n’
        if i < len(partitions) - 1:
            union_query += ') UNION '
        # Else, append ‘) \
        else:
            union_query += ')'
    # Append 'as <table name>'
    union_query += (') as ' + target_table_name)
    # Replace <table name> in the original query to the generate string
    new_query = query.replace(target_table_name, union_query)
    # Return the modified query
    return new_query

def exportQuery(output_queries_path, query_file_name, query):
    query_file_path = os.path.join(output_queries_path, query_file_name + '.sql')
    with open(query_file_path, 'w') as query_file:
        query_file.write(query)