# schemaless-data-generator

For the design description, see [Schemaless Data Experiment on Orca](https://docs.google.com/document/d/1R7ENQvLVNHQ-DG-sga0tfgGWJIkobQT77HQFVKUvxH8/edit#).

## Folder Structure

```
./configuration: yaml files
./schemas: schema yaml files
```

## Bash files

```
runner.sh: move generated files and run the experiment.
```

## Usage
```
// to generate files
python dataset-generator.py <configuration file path> <output format; csv or json>
```