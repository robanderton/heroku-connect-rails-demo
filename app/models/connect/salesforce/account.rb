require_dependency 'connect/salesforce/base'

module Connect
  module Salesforce
    class Account < Base

      has_many :contacts,
        dependent: :destroy,
        foreign_key: :account__externalid__c,
        primary_key: :externalid__c

      has_externalid

      validates :name, length: { maximum: 255 }, presence: true
      validates :phone, length: { maximum: 40 }
      validates :website, length: { maximum: 255 }

    end
  end
end
