class CreateSalesforceAccount < ActiveRecord::Migration

  def up
    create_table(table_name) do |t|
      t.string   :sfid, limit: 18, index: { name: 'hcu_idx_account_sfid', unique: true }
      t.string   :name, limit: 255
      t.string   :phone, limit: 40
      t.string   :website, limit: 255
      t.string   :externalid__c, limit: 36, index: { name: 'hcu_idx_account_externalid__c', unique: true }
      t.boolean  :isdeleted
      t.datetime :createddate
      t.datetime :systemmodstamp, index: { name: 'hc_idx_account_systemmodstamp' }
      t.string   :_hc_lastop, limit: 32
      t.text     :_hc_err
    end unless table_exists?(table_name)
  end

  def down
    drop_table(table_name)
  end

  protected

    def table_name
      @table_name ||= Connect::Salesforce::Base.schema_qualified_name(:account)
    end

end
