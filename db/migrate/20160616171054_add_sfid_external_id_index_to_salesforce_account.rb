class AddSfidExternalIdIndexToSalesforceAccount < ActiveRecord::Migration

  def up
    add_index(table_name, [ :sfid, :externalid__c ], name: new_index_name, unique: true) unless index_name_exists?(table_name, new_index_name, false)
  end

  def down
    execute("DROP INDEX IF EXISTS #{Connect::Salesforce::Base.schema_qualified_name(new_index_name)};")
  end

  protected

    def new_index_name
      :idx_account_sfid_externalid__c
    end

    def table_name
      @table_name ||= Connect::Salesforce::Base.schema_qualified_name(:account)
    end

end
