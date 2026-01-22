# Upgrading

## Steps for v0.9.0 upgrade

DocumentDownloads is now removed from the codebase. Ensure you:

* Have completed the "Steps for v0.6.0 upgrade"
* Remove the ENV var `GBL_ADMIN_REFERENCES_MIGRATED` from your application
* Delete the FormElement entry for FormFeature > Multiple Download Links
* Update your config/initializers/mime_types.rb to use `Mime::Type.register "text/csv", :csv_document_licensed_access_links`

With these above steps complete, you can upgrade to v0.9.0

## Steps for v0.7.0 upgrade

This release moves document distribution imports to the background queue. It also adds support for `document_data_dictionaries`.

### Application Changes

This is a list of manual changes that need to be made to the parent Rails application to successfully upgrade from v0.6.0 to v0.7.0.

For reference, see the changes in the BTAA Geoportal for our [v5.13.0](https://github.com/geobtaa/geoportal/commit/597fbe33627cbce3706b8a3b4da706069d55146b) and [v5.13.1](https://github.com/geobtaa/geoportal/commit/cd638442af6a52b3b4ba17d3b040f7dc9c9d87b2) releases.

#### RUBYGEMS

* Update `geoblacklight_admin` gem to v0.7.0

#### COPY MIGRATIONS

* Copy migration for `document_data_dictionaries` table
  * db/migrate/20241204163117_create_document_data_dictionaries.rb  
* Copy migration for `document_data_dictionary_entries` table
  * db/migrate/20241204163117_create_document_data_dictionary_entries.rb
* Copy migration for the `import_distributions` related tables
  * db/migrate/20250113213655_import_distributions.rb
  * import_distributions
  * import_distribution_transitions
  * import_document_distributions
  * import_document_distribution_transitions
  

#### ROUTES

* Add new routes for import distributions

```ruby
  # Import Distributions
  resources :import_distributions do
    resources :import_document_distributions, only: [:show]
    patch :run, on: :member
  end
```

* Add new routes for document data dictionaries

```ruby
  concern :gbl_exportable, Geoblacklight::Routes::Exportable.new
  concern :gbl_admin_data_dictionariesable, GeoblacklightAdmin::Routes::DataDictionariesable.new
  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :gbl_exportable
    concerns :gbl_admin_data_dictionariesable
  end
```

```ruby
  # Nested within Documents, alongside Document Assets and Document Downloads, etc.

  # Data Dictionaries
  resources :document_data_dictionaries, path: "data_dictionaries" do
    collection do
      get "import"
      post "import"
      get "destroy_all"
      post "destroy_all"
    end
    resources :document_data_dictionary_entries, path: "entries" do
      collection do
        post "sort"
        get "destroy_all"
        post "destroy_all"
      end
    end
  end
```

#### SOLR DOCUMENT

* Add `kithe_model` method to `SolrDocument`

```ruby
def kithe_model
  @kithe_model ||= Kithe::Model.find(self.id)
end
```

#### CATALOG CONTROLLER

* Add data dictionaries show tools partial:

```ruby
config.add_show_tools_partial :gbl_admin_data_dictionaries, partial: 'gbl_admin_data_dictionaries', if: proc { |_context, _config, options| options[:document] && options[:document]&.kithe_model&.document_data_dictionaries&.present? }
```

* Add `data_dictionaries` action

```ruby
def data_dictionaries
  @response, @documents = action_documents
  respond_to do |format|
    format.html do
      return render layout: false if request.xhr?
      # Otherwise draw the full page
    end
  end
end
```

## Steps for v0.6.0 upgrade

This release includes a significant number of changes to the GBL Admin application. Principally, the introduction of the `document_distributions` table to replace the `dct_references_s` field in the `documents` table. This change moves us from a single CSV file workflow to a multi-file CSV workflow. One CSV file is used to create the `documents` table and one or more CSV files are used to create the `document_distributions` table.

### Application Changes

This is a list of manual changes that need to be made to the parent Rails application to successfully upgrade from v0.5.0 to v0.6.0.

#### COPY MIGRATIONS

* Copy migration for `reference_types` table
* Copy migration for `documents_references` table
* Copy migration to rename `documents_references` to `document_distributions`

#### SEED REFERENCE TYPES

* Seed the `reference_types` table

#### MIMETYPE UPDATE

* Update the mime type configuration in the application (config/initializers/mime_types.rb)

#### ROUTES

* New routes for reference types and document distributions

#### ENV VAR

* Set env var for `GBL_ADMIN_REFERENCES_MIGRATED` to `false`

#### DATA MIGRATION

* In the Elements table, update the "References" element's import and export functions to distributions_json (from `references_json`)
* Migrate existing AttrJson `dct_reference_s` values to the new `document_distributions` table
  * `rake geoblacklight_admin:distributions:migrate`
* Audit the distributions migration
  * `rake geoblacklight_admin:distributions:audit`
* Set environment variable for `GBL_ADMIN_DISTRIBUTIONS_MIGRATED` to `true`
