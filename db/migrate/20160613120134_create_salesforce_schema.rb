class CreateSalesforceSchema < ActiveRecord::Migration
  def up
    create_schema(Connect::Salesforce::Base.schema_name) unless schema_exists?(Connect::Salesforce::Base.schema_name)
  end

  def down
    drop_schema(Connect::Salesforce::Base.schema_name) unless Connect::Salesforce::Base.schema_name == 'public'
  end
end
