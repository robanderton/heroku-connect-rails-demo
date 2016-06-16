class AddAccountIdExternalIdForeignKeyToSalesforceContact < ActiveRecord::Migration

  def up
    # Foreign key with cascading updates and deletes to ensure that when
    # parent record (SFID, External ID) pair is updated, so are all children
    execute %{
      ALTER TABLE #{contact_table_name}
        ADD CONSTRAINT #{foreign_key_name}
        FOREIGN KEY (accountid, account__externalid__c)
        REFERENCES #{account_table_name}(sfid, externalid__c)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
    }.squish
  end

  def down
    remove_foreign_key contact_table_name, name: foreign_key_name
  end

  protected

    def account_table_name
      @account_table_name ||= Connect::Salesforce::Base.schema_qualified_name(:account)
    end

    def contact_table_name
      @contact_table_name ||= Connect::Salesforce::Base.schema_qualified_name(:contact)
    end

    def foreign_key_name
      :fk_contact_accountid_account__externalid__c
    end

end
