module Connect
  module Salesforce
    class Base < ::Connect::Base

      # Configure schema name for objects
      self.abstract_class = true
      self.schema_name = 'salesforce'
      self.table_name_prefix = "#{self.schema_name}."

    end
  end
end
