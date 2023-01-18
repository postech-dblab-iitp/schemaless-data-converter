import os
import utils

## TODO: Replace this into class, and make configuration yaml and sceham yaml as a class member.

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
        new_table_name = getNewPartitionedTableName(target_table_name, partition)
        
        # Print CREATE TABLE
        create_sql = 'CREATE TABLE ' + new_table_name + ' ( \n'
        
        # Get columns without removed ones
        columns_wo_removing = utils.getSchemaColumnsWithoutRemovedColumns(schema_yaml['columns'], configuration_yaml[partition])
        
        # Iterate over columns and print        
        for i, column in enumerate(columns_wo_removing):
            column_string = schema_yaml[column]
            create_sql += column 
            create_sql += '\t'
            create_sql += column_string
            if i < len(columns_wo_removing) - 1:
                create_sql += ','
            create_sql += '\n'
        
        # Print table creation options
        create_sql += ') '
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
    exportOtherTableTemplates(sql_file_path, target_table_name, 'load', lambda x: x ,'\n\n\n\n')
    return

def generateExportPkeysSQL(configuration_yaml, schema_yaml):
    # Create empty file
    sql_file_name = 'tpch-pkeys.sql'
    sql_file_path = createSQLFile(sql_file_name, configuration_yaml)
    
    # Get table name
    target_table_name = configuration_yaml['table_name']
    
    # Iterate over partitions
    partitions = configuration_yaml['partitions']
    for partition in partitions:
        # Set the table name
        new_table_name = getNewPartitionedTableName(target_table_name, partition)
        # Get primary keys
        primary_keys = schema_yaml['primary_keys']
        # Print ALTER TABLE <new_table_name> ADD PRIMARY KEY <primary_keys>
        alter_table_sql = 'ALTER TABLE ' + new_table_name + ' ADD PRIMARY KEY ('
        alter_table_sql += ','.join(primary_keys)
        alter_table_sql += ');'
        alter_table_sql += '\n'
        
        # Print final string
        with open(sql_file_path, 'a') as sql_file:
            sql_file.write(alter_table_sql)
    
    # Print other tables
    exportOtherTableTemplates(sql_file_path, target_table_name, 'pkeys', lambda x: x, '\n')
    return

def generateExportAlterSQL(configuration_yaml, schema_yaml):
    # Create empty file
    sql_file_name = 'tpch-alter.sql'
    sql_file_path = createSQLFile(sql_file_name, configuration_yaml)
    
    # Get table name
    target_table_name = configuration_yaml['table_name']
    
    # Iterate over partitions
    partitions = configuration_yaml['partitions']
    for partition in partitions:
        # Set the table name
        new_table_name = getNewPartitionedTableName(target_table_name, partition)
        
        # Replace SQL's table name to new table name
        template_sql_file_path = getTemplateSQLFilePath('alter', target_table_name)
        with open(template_sql_file_path, 'r') as template_sql_file:
            template_sql_string = template_sql_file.read()
            template_sql_string = template_sql_string.replace(target_table_name.upper(), new_table_name.upper())
        
            # Write replaced string
            with open(sql_file_path, 'a') as sql_file:
                sql_file.write(template_sql_string + '\n')
        
    # Print other tables
    def replaceTargetTableToNewName(original_sql_string):
        upp_target_table_name = target_table_name.upper()
        # Check original string contains the table
        if upp_target_table_name in original_sql_string:
            new_sql_string = ''
            
            # Iterate partitions
            partitions = configuration_yaml['partitions']
            for partition in partitions:
                # Replace the original table to new table
                new_table_name = getNewPartitionedTableName(target_table_name, partition)
                new_sql_string += original_sql_string.replace(upp_target_table_name, new_table_name)
                new_sql_string += '\n'
            return new_sql_string
        else:
            return original_sql_string
        
    exportOtherTableTemplates(sql_file_path, target_table_name, 'alter', replaceTargetTableToNewName, '\n')
    return

def generateExportIndexSQL(configuration_yaml, schema_yaml):
    # Create empty file
    sql_file_name = 'tpch-index.sql'
    sql_file_path = createSQLFile(sql_file_name, configuration_yaml)
    
    # Get table name
    target_table_name = configuration_yaml['table_name']
    
    # Iterate over partitions
    partitions = configuration_yaml['partitions']
    for partition in partitions:
        # Set the table name
        new_table_name = getNewPartitionedTableName(target_table_name, partition)
        
        # Get removed columns
        partition_configuration = configuration_yaml[partition]
        removed_columns = utils.getRemovedColumns(partition_configuration)
        
        # Iterate over index strings
        new_sql_string = ''
        template_sql_file_path = getTemplateSQLFilePath('index', target_table_name)
        with open(template_sql_file_path, 'r') as template_sql_file:
            template_index_sql_string = template_sql_file.readline()
            # Check string contains removed columns
            removed_column_exists = any(column in template_index_sql_string for column in removed_columns)
            # If not contains, then create this index
            if not removed_column_exists:
                new_sql_string += template_index_sql_string.replace(target_table_name.upper(), new_table_name)
                new_sql_string += '\n'
        
        # Write replaced string
        with open(sql_file_path, 'a') as sql_file:
            sql_file.write(new_sql_string)
        
    exportOtherTableTemplates(sql_file_path, target_table_name, 'index', lambda x: x, '\n')
    return

def generateExportAnalyzeSQL(configuration_yaml, schema_yaml):
    # Create empty file
    sql_file_name = 'tpch-analyze.sql'
    sql_file_path = createSQLFile(sql_file_name, configuration_yaml)
    
    # Get table name
    target_table_name = configuration_yaml['table_name']
    
    # Iterate over partitions
    partitions = configuration_yaml['partitions']
    for partition in partitions:
        # Set the table name
        new_table_name = getNewPartitionedTableName(target_table_name, partition)
        # Print final string
        with open(sql_file_path, 'a') as sql_file:
            sql_file.write('analyze ' + new_table_name + ';\n')
            
    # Print other tables
    exportOtherTableTemplates(sql_file_path, target_table_name, 'analyze', lambda x: x, '\n')
    return

def getNewPartitionedTableName(target_table_name, partition):
    new_table_name = target_table_name + '_' + partition
    return new_table_name.upper()

def createSQLFile(sql_file_name, configuration_yaml):
    output_folder_path = utils.getOutputFolderPath(configuration_yaml)
    sql_file_path = os.path.join(output_folder_path, sql_file_name)
    os.system('touch ' + sql_file_path)
    return sql_file_path

def getTemplateSQLFilePath(phase_name, table_name):
    phase_folder = os.path.join(tpch_template_folder, phase_name)
    sql_file_path = os.path.join(phase_folder, table_name) + '.sql'
    return sql_file_path

def exportOtherTableTemplates(sql_file_path, target_table_name, phase_name, string_converter, end_of_table_string):
    other_tables = [table for table in tables_tpch if table != target_table_name]
    for other_table in other_tables:
        sql_template_file_path = getTemplateSQLFilePath(phase_name, other_table)
        with open(sql_template_file_path, 'r') as sql_template_file:
            with open(sql_file_path, 'a') as sql_file:
                sql_file.write(string_converter(sql_template_file.read()))
                sql_file.write(end_of_table_string)