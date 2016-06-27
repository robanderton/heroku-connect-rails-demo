class CreateSalesforceAccountExternalIdTrigger < ActiveRecord::Migration

  def up
    down

    execute %{
      CREATE TRIGGER account_externalid_trigger
        AFTER INSERT OR UPDATE ON #{table_name}
        FOR EACH ROW
        WHEN (NULLIF(TRIM(NEW.externalid__c), '') IS NULL)
        EXECUTE PROCEDURE externalid_uuid_proc();
    }.squish
  end

  def down
    execute %{
      DROP TRIGGER IF EXISTS account_externalid_trigger ON #{table_name};
    }.squish
  end

  protected

    def table_name
      @table_name ||= Connect::Salesforce::Base.schema_qualified_name(:account)
    end

end
