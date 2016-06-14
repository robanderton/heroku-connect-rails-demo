module Connect

  class Base < ::ActiveRecord::Base

    # Stores the Postgres schema name to be used by models
    class_attribute :schema_name, instance_accessor: false

    class << self

      # Use a v4 UUID for External IDs
      def generate_external_id
        SecureRandom.uuid
      end

      # Call from subclasses to have an External ID automatically populated on create
      def has_external_id(attribute = :externalid__c)
        attr_readonly(attribute)
        before_create { self.send("#{attribute}=", self.class.generate_external_id) unless self.send("#{attribute}?")}
      end

      # Convenience method to prefix table names with the schema name
      def schema_qualified_name(name)
        "#{schema_name}.#{name}"
      end

    end

    self.abstract_class = true
    self.inheritance_column = nil
    self.pluralize_table_names = false
    self.schema_name = 'public'
    self.table_name_prefix = "#{self.schema_name}."

    # Alias timestamp fields to look more like ActiveRecord timestamps
    alias_attribute :created_at, :createddate
    alias_attribute :updated_at, :systemmodstamp

    attr_readonly :sfid

    private

      # Timestamps only get populated when data is received from Salesforce
      # causing problems in the interim - this allows Rails to set the initial
      # values which will then be overwritten when the next Salesforce sync occurs
      def timestamp_attributes_for_create
        [ :createddate, :systemmodstamp ]
      end

      def timestamp_attributes_for_update
        [ :systemmodstamp ]
      end

  end
end
