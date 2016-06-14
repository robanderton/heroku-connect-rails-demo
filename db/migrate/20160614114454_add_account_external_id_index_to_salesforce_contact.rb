class AddAccountExternalIdIndexToSalesforceContact < ActiveRecord::Migration

  def up
    add_index(table_name, :account__externalid__c, name: new_index_name) unless index_name_exists?(table_name, new_index_name, false)
  end

  def down
    # TODO: replace with remove_index when it supports schema names (fixed in Rails5)
    execute("DROP INDEX IF EXISTS #{Connect::Salesforce::Base.schema_qualified_name(new_index_name)};")
  end

  protected

    def new_index_name
      :idx_contact_account__externalid__c
    end

    def table_name
      @table_name ||= Connect::Salesforce::Base.schema_qualified_name(:contact)
    end

end
