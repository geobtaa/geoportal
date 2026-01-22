# GBL Admin - Development Notes

## Adding new dct_references_s keys

You will need to modify all the files listed below to ensure the new field is fully supported in the application.

### REFERENCE_VALUES
Add the new dct_references_s option to Document::Reference::REFERENCE_VALUES
* app/models/document/reference.rb

### FIELD MAPPINGS
Update: self.uri_2_category_references_mappings
* app/models/geoblacklight_admin/field_mappings_btaa_aardvark.rb

### Schema
Update: dct_references_import_mappings
Update: dct_references_mappings
* app/models/geoblacklight_admin/schema.rb

### LOCALES
Update: document/reference -> categories
* config/locales/documents.en.yml

### Settings
* lib/generators/geoblacklight_admin/templates/config/settings.yml

### Tests — Schema Support
Add the new field(s) and some example data to the schema_support.csv file:
* test/fixtures/files/schema_support.csv

