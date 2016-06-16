class AddExternalIdDefaultAndPartialIndexToSalesforceAccount < ActiveRecord::Migration

  def up
    drop_external_id_index

    # Partial index to allow multiple entries with blank External ID
    add_index(table_name, :externalid__c, name: new_index_name, where: "externalid__c != ''", unique: true)
    change_column_default(table_name, :externalid__c, '')

    execute %{
      UPDATE #{table_name}
      SET externalid__c = ''
      WHERE externalid__c IS NULL;
    }.squish
  end

  def down
    drop_external_id_index

    execute %{
      UPDATE #{table_name}
      SET externalid__c = NULL
      WHERE externalid__c = '';
    }.squish

    change_column_default(table_name, :externalid__c, nil)
    add_index(table_name, :externalid__c, name: new_index_name, unique: true)
  end

  protected

    def drop_external_id_index
      execute("DROP INDEX IF EXISTS #{Connect::Salesforce::Base.schema_qualified_name(new_index_name)};")
    end

    def new_index_name
      :hcu_idx_account_externalid__c
    end

    def table_name
      @table_name ||= Connect::Salesforce::Base.schema_qualified_name(:account)
    end

end
