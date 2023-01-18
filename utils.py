import os
from pathlib import Path

def getOutputFolderPath(configuration_yaml):
    title = configuration_yaml['title']
    output_folders_path = configuration_yaml['output_folders_path']
    output_folder_path = os.path.join(output_folders_path, title)
    return output_folder_path

def getPartitionOutputFilePath(configuration_yaml, partition):
    file_name = getPartitionFileBaseName(configuration_yaml, partition) + '.csv'
    output_folder_path = getOutputFolderPath(configuration_yaml)
    output_file_path = os.path.join(output_folder_path, file_name)
    return output_file_path

def getPartitionFileBaseName(configuration_yaml, partition):
    data_file_path = configuration_yaml['data_file_path']
    base_file_name = Path(data_file_path).stem
    return base_file_name + '_' + partition

def getSchemaColumnsWithoutRemovedColumns(partition_configuration, schema_columns):
    # If column_removing is active
    column_removing_configuration = partition_configuration['column_removing']
    if column_removing_configuration['activate']:
        columns_to_remove = column_removing_configuration['columns']
        column_indicies = [schema_columns.index(column_to_remove) for column_to_remove in columns_to_remove]
        new_schema_columns = [column for i, column in enumerate(schema_columns) if i not in column_indicies]
        return new_schema_columns
    else: # If no to-be-removed columns, just return the original one
        return schema_columns