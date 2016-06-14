require_dependency 'connect/salesforce/base'

module Connect
  module Salesforce
    class Account < Base

      with_options dependent: :destroy do
        has_many :contacts,
          foreign_key: :accountid,
          primary_key: :sfid

        has_many :external_contacts,
          class_name: 'Contact',
          foreign_key: :account__externalid__c,
          primary_key: :externalid__c
      end

      has_external_id

      validates :name, length: { maximum: 255 }, presence: true
      validates :phone, length: { maximum: 40 }
      validates :website, length: { maximum: 255 }

    end
  end
end
