class AddAccountExternalIdDefaultToSalesforceContact < ActiveRecord::Migration

  def up
    change_column_default(table_name, :account__externalid__c, '')

    execute %{
      UPDATE #{table_name}
      SET account__externalid__c = ''
      WHERE account__externalid__c IS NULL;
    }.squish
  end

  def down
    execute %{
      UPDATE #{table_name}
      SET account__externalid__c = NULL
      WHERE account__externalid__c = '';
    }.squish

    change_column_default(table_name, :account__externalid__c, nil)
  end

  protected

    def table_name
      @table_name ||= Connect::Salesforce::Base.schema_qualified_name(:contact)
    end

end
