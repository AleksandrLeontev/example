#app/serializers/affiliate_serializer.rb
class AffiliateSerializer < ActiveModel::Serializer
  attributes :id, :state, :payment, :commitment_days, :participation_start, :participation_end, 

  has_one :primary_contact
  has_one :dma
  has_many :secondary_contacts
end
