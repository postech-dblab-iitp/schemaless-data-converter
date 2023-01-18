import os
import utils

tables_tpch = ['part', 'region', 'nation', 'supplier', 'customer', 'partsupp', 'orders', 'lineitem']
tpch_template_folder = './templates/tpch'

def generateExportDataSetupSQLFilesTPCH(configuration_yaml, schema_yaml):
    generateExportLoadSQL(configuration_yaml, schema_yaml)
    generateExportPkeysSQL(configuration_yaml, schema_yaml)
    generateExportAlterSQL(configuration_yaml, schema_yaml)
    generateExportIndexSQL(configuration_yaml, schema_yaml)
    generateExportAnalyzeSQL(configuration_yaml, schema_yaml)

def generateExportLoadSQL(configuration_yaml, schema_yaml):
    # Create empty file
    sql_file_name = 'tpch-load.sql'
    sql_file_path = createSQLFile(sql_file_name, configuration_yaml)
    
    # Get table name
    target_table_name = configuration_yaml['table_name']
    
    # Iterate over partitions
    partitions = configuration_yaml['partitions']
    for partition in partitions:
        # Set the new table name
        new_table_name = target_table_name + '_' + partition
        
        # Print CREATE TABLE
        create_sql = 'CREATE TABLE ' + new_table_name + ' ( \n'
        
        # Get columns without removed ones
        columns_wo_removing = getPartitionColumnsWithoutRemovedOnes(configuration_yaml, schema_yaml, partition)
        
        # Iterate over columns and print
        for column in columns_wo_removing:
            column_string = schema_yaml[column]
            create_sql += column 
            create_sql += '\t'
            create_sql += column_string
            create_sql += '\n'
        create_sql += ') '
        
        # Print table creation options
        create_sql += schema_yaml['create_option']
        create_sql += ';\n\n'
        
        # Print \COPY .. FROM
        output_file_base_name = utils.getPartitionFileBaseName(configuration_yaml, partition)
        create_sql += '\COPY ' + new_table_name + ' FROM ' + '\'/tmp/dss-data/' + output_file_base_name + '.csv\'' + ' WITH csv DELIMITER \'|\';'
        create_sql += '\n\n\n\n'
        
        # Print final string
        with open(sql_file_path, 'a') as sql_file:
            sql_file.write(create_sql)
            
    # Print other tables
    exportOtherTableTemplates(sql_file_path, target_table_name, 'load')
    return

def generateExportPkeysSQL(configuration_yaml, schema_yaml):
    
    return

def generateExportAlterSQL(configuration_yaml, schema_yaml):
    return

def generateExportIndexSQL(configuration_yaml, schema_yaml):
    return

def generateExportAnalyzeSQL(configuration_yaml, schema_yaml):
    return

def createSQLFile(sql_file_name, configuration_yaml):
    output_folder_path = utils.getOutputFolderPath(configuration_yaml)
    sql_file_path = os.path.join(output_folder_path, sql_file_name)
    os.system('touch ' + sql_file_path)
    return sql_file_path

def getTemplateSQLFilePath(phase_name, table_name):
    phase_folder = os.path.join(tpch_template_folder, phase_name)
    sql_file_path = os.path.join(phase_folder, table_name) + '.sql'
    return sql_file_path

def getPartitionColumnsWithoutRemovedOnes(configuration_yaml, schema_yaml, partition):    
    schema_columns = schema_yaml['columns']
    partition_configuration = configuration_yaml[partition]
    return utils.getSchemaColumnsWithoutRemovedColumns(schema_columns, partition_configuration)

def exportOtherTableTemplates(sql_file_path, target_table_name, phase_name):
    other_tables = [table for table in tables_tpch if table != target_table_name]
    for other_table in other_tables:
        sql_template_file_path = getTemplateSQLFilePath(phase_name, other_table)
        with open(sql_template_file_path, 'r') as sql_template_file:
            with open(sql_file_path, 'a') as sql_file:
                sql_file.write(sql_template_file.read())
                sql_file.write('\n\n\n\n')