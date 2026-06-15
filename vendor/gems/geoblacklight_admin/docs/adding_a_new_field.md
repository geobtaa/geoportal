# GBL Admin - Development Notes

## Adding a new field

You will need to modify all the files listed below to ensure the new field is fully supported in the application.

### DB Seeds
Add the new field the seeds_elements.csv file:
* db/seeds_elements.csv

Also add the new field to the seeds_form_elements.csv file:
* db/seeds_form_elements.csv

### Locales
For repeatable/multi-valued elements, to ensure the field label for additional entries is sane, add the new field to the documents locales file:
* config/locales/documents.en.yml

### JSON Schema
Add the new field to the JSON schema file:
* lib/generators/geoblacklight_admin/templates/config/geomg_aardvark_schema.json

### Testing
Add the new field and some example data to the schema_support.csv file:
* test/fixtures/files/schema_support.csv
