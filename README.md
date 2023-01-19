# schemaless-data-generator

For the design description, see [Schemaless Data Experiment on Orca](https://docs.google.com/document/d/1R7ENQvLVNHQ-DG-sga0tfgGWJIkobQT77HQFVKUvxH8/edit#).

## Folder Structure

```
./configuration: yaml files
./schemas: schema yaml files
./data: data csv files (not included in the git project)
./templates: template sql files for data setup sql file generation
./results: generated csv files and SQL files
```

## Bash files

```
runner.sh: move generated files and run the experiment.
test.sh: test script
tpch_copy.sh: copy csv files and sql files from TPCH-Greenplum to data/tpch and queries/tpch
```

## Usage
```
// to generate files
python generator.py <configuration file path>
// to run TPCH benchmark using generated dataset
bash runner.sh <DB name> <Generated data path>
// e.g, bash runner.sh tpch ./results/test_supplier
```

## TODOs

In sqlFileGenerator.py, Replace this into class, and make configuration yaml and sceham yaml as a class member.

How to handle table alias?? for example, SELECT .. FROM supplier as s; . We cannot just substitute supplier

How to handler supplier_no or agg_lineitem?? (simple way? read one more character in the front and the back.)