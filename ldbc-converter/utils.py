import os
from pathlib import Path

def getOutputFolderPath(configuration_yaml):
    output_folders_path = configuration_yaml['output_folders_path']
    output_folder_path = os.path.join(output_folders_path, '')
    return output_folder_path

def getUnifiedOutputFilePath(configuration_yaml, format = 'csv'):
    file_name = getUnionFileBaseName(configuration_yaml) + '.' + format
    output_folder_path = getOutputFolderPath(configuration_yaml)
    output_file_path = os.path.join(output_folder_path, file_name)
    return output_file_path

def getUnionFileBaseName(configuration_yaml):
    data_file_path = configuration_yaml['data_file_path']
    base_file_name = Path(data_file_path).stem
    return base_file_name

def getPartitionOutputFilePath(configuration_yaml, partition, format = 'csv'):
    file_name = getPartitionFileBaseName(configuration_yaml, partition) + '.' + format
    output_folder_path = getOutputFolderPath(configuration_yaml)
    output_file_path = os.path.join(output_folder_path, file_name)
    return output_file_path

def getPartitionTableBasedName(table_name, partition):
    return table_name + '_' + partition

def getPartitionFileBaseName(configuration_yaml, partition):
    data_file_path = configuration_yaml['data_file_path']
    base_file_name = Path(data_file_path).stem
    return base_file_name + '_' + partition

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
    
def getRemovedColumns(partition_configuration):
    column_removing_configuration = partition_configuration['column_removing']
    if column_removing_configuration['activate']:
        return column_removing_configuration['columns']
    else: # If no to-be-removed columns, just return the original one
        return []
        
def getTypeConversionColumns(partition_configuration):
    type_conversion_configuration = partition_configuration['type_conversion']
    if type_conversion_configuration['activate']:
        return type_conversion_configuration['columns']
    else:
        return []
    
def getConversionType(partition_configuration, column_name):
    type_conversion_configuration = partition_configuration['type_conversion']
    type_conversion_columns = type_conversion_configuration['columns']
    type_columns = type_conversion_configuration['types']
    column_index = type_conversion_columns.index(column_name)
    return type_columns[column_index]