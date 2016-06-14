# Heroku Connect Rails Demo

## Salesforce Configuration

* Use a free developer edition account or a sandbox

* Add a custom External ID field to the Account object: (Salesforce Classic UI)

  - Setup -> Build -> Customize -> Accounts -> Fields
  - Scroll to 'Account Custom Fields & Relationships' and click 'New'
  - Choose 'Text' as the field type and click next
  - Enter 'ExternalId' as the Field Label and name
  - Set length to 36
  - Tick 'Do not allow duplicate values' and ensure 'Treat "ABC" and "abc" as duplicate values (case insensitive)' is selected
  - Tick 'Set this field as the unique record identifier from an external system'
  - Click Next
  - Click Next (accept field level security defaults)
  - Click Save (accept layout defaults)

## Deployment

* Open the Heroku Connect dashboard to complete setup:

    * connect to the same database as any non-Connect mapped tables (multiple databases are not supported)
    * use the default `salesforce` database schema name
    * use the "Winter '15, v32.0" API

* Import mapping configuration using the `db/connect/salesforce_mappings.json` file.

* Run the Rails migrations *after* the mappings have been imported.
