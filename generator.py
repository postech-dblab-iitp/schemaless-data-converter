import sys
import csv
import yaml
import os
import random

def printAndExit(print_string):
    print(print_string)
    sys.exit()

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

        # Check portion, column_removing, type_conversion exists
        option_keys = ['portion', 'column_removing', 'type_conversion']
        for option_key in option_keys:
            if partition_configuration[option_key] is None:
                printAndExit('No ' + option_key + ' in ' + partition)
                
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
                
        # Check type_conversion configurations
        type_conversion_configuration = partition_configuration['type_conversion']
        if type_conversion_configuration['activate']:
            tc_columns = type_conversion_configuration['columns']
            types = type_conversion_configuration['types']
            checkColumnsValidAndNonPrimary(tc_columns)
            if len(tc_columns) != len(types):
                printAndExit('Types and columns are not the same length')

            # Check common column exists
            for tc_column in tc_columns:
                if tc_column in cr_columns:
                    printAndExit(tc_column + ' is common in column removing and type_conversion')
        
    # Check portion sum equals to 100
    if portion_sum != 100:
        printAndExit('Sum of portion is not 100')
    return

def validateArguments():
    if len(sys.argv) != 2:
        print('Invalid arguments')
        sys.exit()

#####################
### MAIN FUNCTION ###
#####################
validateArguments()
configuration_file_path = sys.argv[1]

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
        
        # Create output folder
        title = configuration_yaml['title']
        output_folders_path = configuration_yaml['output_folders_path']
        output_path = os.path.join(output_folders_path, title)
        if os.path.exists(output_path):
            os.system('rm -rf ' + output_path)
        os.mkdir(output_path)
        
        # Read data file and store tuples in an array
        original_tuples = []
        data_file_path = configuration_yaml['data_file_path']
        with open(data_file_path) as data_file:
            data_file_reader = csv.reader(data_file, delimiter='|')
            for row in data_file_reader:
                if len(row) != len(schema_columns): printAndExit('Invalid row!')
                original_tuples.append(row)
                
        # Create an index list
        num_tuples = len(original_tuples)
        index_list = list(range(0, num_tuples))
        
        # Shuffle index list
        random.shuffle(index_list)
        
        # Iterate over partitions
        partitions = configuration_yaml['partitions']
        start_index = 0
        for partition in partitions:
            # Get the parttion's configuration
            partition_configuration = configuration_yaml[partition]
            
            # Calculate the range of tuples
            portion = partition_configuration['portion']
            tuples_range = (start_index, start_index + portion - 1)
            start_index += portion
            
            # Iterate over tuples
            for o_tuple in original_tuples:
                # If type_conversion is active
                type_conversion_configuration = partition_configuration['type_conversion']
                if type_conversion_configuration['activate']:
                    # Iterate over columns to convert
                    for column_to_convert in type_conversion_configuration['columns']:
                        # Get the index of the column
                        column_index = schema_columns.index(column_to_convert)
                
                # If column_removing is active
                column_removing_configuration = partition_configuration['column_removing']
                if column_removing_configuration['activate']:
                    # Create a new tuple and substitue
                    columns_to_remove = column_removing_configuration['columns']
                    column_indicies = [schema_columns.index(column_to_remove) 
                                        for column_to_remove in columns_to_remove]
                    o_tuple = [v for i, v in enumerate(o_tuple) if i not in column_indicies]
                    
                    # Check deletion done well
                    if len(o_tuple) != (len(schema_columns) - len(columns_to_remove)): 
                        printAndExit('Invalid column deletion!')