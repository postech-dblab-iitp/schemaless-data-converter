# schemaless-data-generator

For the design description, see [Schemaless Data Experiment on Orca](https://docs.google.com/document/d/1R7ENQvLVNHQ-DG-sga0tfgGWJIkobQT77HQFVKUvxH8/edit#).

## Folder Structure

```
./configuration: yaml files
./schemas: schema yaml files
./data: data csv files (not included in the git project)
./templates: template sql files for data setup sql file generation
./results: generated csv files and SQL files
runner.sh: move generated files and run the experiment.
test.sh: test script
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