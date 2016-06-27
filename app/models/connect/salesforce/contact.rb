require_dependency 'connect/salesforce/base'

module Connect
  module Salesforce
    class Contact < Base

      belongs_to :account,
        foreign_key: :account__externalid__c,
        primary_key: :externalid__c

      validates_presence_of :email, :firstname, :lastname

      validates :firstname, length: { maximum: 40 }, presence: true
      validates :lastname, length: { maximum: 80 }, presence: true

      validates :email, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }

    end
  end
end
