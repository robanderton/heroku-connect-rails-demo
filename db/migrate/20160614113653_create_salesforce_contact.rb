class CreateSalesforceContact < ActiveRecord::Migration

  def up
    create_table(table_name) do |t|
      t.string   :sfid, limit: 18, index: { name: 'hcu_idx_contact_sfid', unique: true }
      t.string   :accountid, limit: 18, index: { name: 'hc_idx_contact_accountid' }
      t.string   :name, limit: 121
      t.string   :email, limit: 80
      t.string   :firstname, limit: 40
      t.string   :lastname, limit: 80
      t.string   :account__externalid__c, limit: 36
      t.boolean  :isdeleted
      t.datetime :createddate
      t.datetime :systemmodstamp, index: { name: 'hc_idx_contact_systemmodstamp' }
      t.string   :_hc_lastop, limit: 32
      t.text     :_hc_err
    end unless table_exists?(table_name)
  end

  def down
    drop_table(table_name)
  end

  protected

    def table_name
      @table_name ||= Connect::Salesforce::Base.schema_qualified_name(:contact)
    end

end
