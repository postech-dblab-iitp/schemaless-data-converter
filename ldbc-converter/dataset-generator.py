import sys
import csv
import yaml
import os
import random
import utils
import json

#####################
### VAL FUNCTIONS ###
#####################

# Validate the given configuration file
def validateConfigurationFile(configuration_yaml, schema_yaml):
    # Check partitions are given
    partitions = configuration_yaml['partitions']
    if partitions is None or len(partitions) == 0:
        printAndExit('No partitions given')
        
    # Start actual validation
    portion_sum = 0
    for partition in partitions:
        # Check configurations for each partition exist
        partition_configuration = configuration_yaml[partition]
        if partition_configuration is None:
            printAndExit('No configuration for ' + partition)
            
        # Check portions are in [0, 100]
        portion = partition_configuration['portion']
        if portion < 0 or portion > 100:
            printAndExit('Portion is not in [0, 100] in ' + partition)
        portion_sum += portion

        def checkColumnsValidAndNonPrimary(columns):
            # Check columns not empty
            if len(columns) == 0:
                printAndExit('No columns in column removing of ' + partition)
                
            # Check columns exists and not primary key
            schema_columns = schema_yaml['columns']
            primary_keys = schema_yaml['primary_keys']
            for column in columns:
                if column not in schema_columns:
                    printAndExit(column + ' does not exist in the schema')
                if column in primary_keys:
                    printAndExit(column + ' is primary key')
                
        # Check column_removing configurations
        column_removing_configuration = partition_configuration['column_removing']
        cr_columns = []
        if column_removing_configuration['activate']:
            cr_columns = column_removing_configuration['columns']
            checkColumnsValidAndNonPrimary(cr_columns)
        
    # Check portion sum equals to 100
    if portion_sum != 100:
        printAndExit('Sum of portion is not 100')
    return

def validateArguments():
    if len(sys.argv) != 3:
        print('Invalid arguments')
        sys.exit()
        
def printAndExit(print_string):
    print(print_string)
    sys.exit()

def convertTupleTypes(schema, schema_yaml, p_tuple):
    new_p_tuple = []
    for i, v in enumerate(p_tuple):
        column_name = schema[i]
        type_string = schema_yaml[column_name]
        if v == '':
            new_p_tuple.append('')
        elif 'int' in type_string:
            new_p_tuple.append(int(v))
        elif 'float' in type_string:
            new_p_tuple.append(float(v))
        else:
            new_p_tuple.append(v)
    return new_p_tuple

#####################
### UTIL FUNCTION ###
#####################

def getSchemaColumnsWithoutRemovedColumns(schema_columns, partition_configuration):
    # If column_removing is active
    column_removing_configuration = partition_configuration['column_removing']
    if column_removing_configuration['activate']:
        columns_to_remove = column_removing_configuration['columns']
        column_indicies = [schema_columns.index(column_to_remove) for column_to_remove in columns_to_remove]
        new_schema_columns = [column for i, column in enumerate(schema_columns) if i not in column_indicies]
        return new_schema_columns
    else: # If no to-be-removed columns, just return the original one
        return schema_columns

#####################
### MAIN FUNCTION ###
#####################
validateArguments()
configuration_file_path = sys.argv[1]
output_file_format = sys.argv[2]

# Get configuration file
with open(configuration_file_path, "r") as configuration_file:
    configuration_yaml = yaml.load(configuration_file)
    # Get table schema file
    schema_file_path = configuration_yaml['schema_file']
    with open(schema_file_path, "r") as schema_file:
        schema_yaml = yaml.load(schema_file)
        schema_columns = schema_yaml['columns']
        
        # Validate configuration file
        validateConfigurationFile(configuration_yaml, schema_yaml)
        
        # Read data file and store tuples in an array
        print('Reading data file...')
        original_tuples = []
        data_file_path = configuration_yaml['data_file_path']
        with open(data_file_path) as data_file:
            data_file_reader = csv.reader(data_file, delimiter='|')
            next(data_file_reader)
            for row in data_file_reader:
                if len(row) != len(schema_columns): printAndExit('Invalid row!')
                original_tuples.append(row)
        print('Reading data done...')
                
        # Create an index list
        num_tuples = len(original_tuples)
        index_list = list(range(0, num_tuples))
        
        # Shuffle index list
        random.shuffle(index_list)
        
        # Iterate over partitions
        partitions = configuration_yaml['partitions']
        start_index = 0
        
        # all dicts
        tuple_dicts = []
        
        for partition in partitions:
            print('Processing ' + partition + ' ...')
            
            # Get the parttion's configuration
            partition_configuration = configuration_yaml[partition]
            
            # Calculate the range in shuffled index array
            portion = partition_configuration['portion']
            num_partition_tuples = num_tuples * portion / 100
            tuples_range = (start_index, start_index + num_partition_tuples)
            start_index += num_partition_tuples
            
            # Get sub-array of the shuffled index array in the range
            sub_index_list = index_list[tuples_range[0]:tuples_range[1]]
            partition_tuples = []
            
            # Iterate over the sub-index-array
            for tuple_index in sub_index_list:
                # Get tuple by index
                p_tuple = original_tuples[tuple_index]
                
                # If column_removing is active
                column_removing_configuration = partition_configuration['column_removing']
                if column_removing_configuration['activate']:
                    # Create a new tuple and substitue
                    columns_to_remove = column_removing_configuration['columns']
                    column_indicies = [schema_columns.index(column_to_remove) 
                                        for column_to_remove in columns_to_remove]
                    p_tuple = [v for i, v in enumerate(p_tuple) if i not in column_indicies]
                    
                    # Check deletion done well
                    if len(p_tuple) != (len(schema_columns) - len(columns_to_remove)): 
                        printAndExit('Invalid column deletion!')
                    
                partition_tuples.append(p_tuple)
                
            # Sort tuples based on the primary key values
            schema_columns_after_remove = getSchemaColumnsWithoutRemovedColumns(schema_columns, partition_configuration)
            primary_key_indicies = [schema_columns_after_remove.index(primary_key) for primary_key in schema_yaml['primary_keys']]
            primary_key_sorter = lambda x: [int(x[index]) for index in primary_key_indicies]
            partition_tuples = sorted(partition_tuples, key=primary_key_sorter)
            
            if output_file_format == 'json':
                label = configuration_yaml['table_name']
                for p_tuple in partition_tuples:
                    property_dict = dict(zip(schema_columns_after_remove, convertTupleTypes(schema_columns_after_remove, schema_yaml, p_tuple)))
                    p_tuple_dict = {"labels": [label], "properties": property_dict}
                    tuple_dicts.append(p_tuple_dict)
            else:
                print('Exporting ' + partition + ' ...')
                output_file_path = utils.getPartitionOutputFilePath(configuration_yaml, partition, output_file_format)
                with open(output_file_path, 'w') as csvfile:
                    csvwriter = csv.writer(csvfile, delimiter='|', quoting=csv.QUOTE_NONE)
                    for p_tuple in partition_tuples:
                        csvwriter.writerow(p_tuple)
                print('Exporting ' + partition + ' done')
            print('Processing ' + partition + ' done')

        if output_file_format == 'json':
            print('Shuffling tuples...')
            random.shuffle(tuple_dicts)
            output_file_path = utils.getUnifiedOutputFilePath(configuration_yaml, output_file_format)
            
            if os.path.exists(output_file_path):
                os.remove(output_file_path)
            
            print('Exporting tuples...')
            with open(output_file_path, 'w') as jsonfile:
                for tuple_dict in tuple_dicts:
                    jsonfile.write(json.dumps(tuple_dict) + '\n')
            
        