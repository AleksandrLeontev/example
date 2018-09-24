# app/models/affiliate.rb
class Affiliate < ActiveRecord::Base
  POSSIBLE_STATES = %i(pending approved declined).freeze

  belongs_to :ssp_account
  belongs_to :dma

  has_many :activities, as: :subject, dependent: :destroy
  has_many :secondary_contacts, -> { secondary }, as: :contactable, class_name: Contact.name, dependent: :destroy

  has_one :payment_setting, dependent: :destroy
  has_one :primary_contact, -> { primary }, as: :contactable, class_name: Contact.name, dependent: :destroy

  accepts_nested_attributes_for :secondary_contacts, :primary_contact

  enum state: POSSIBLE_STATES

  scope :approved_before, ->(date) { approved.where('approved_at < ?', date) }
  scope :with_current_participation, -> { where('CURRENT_DATE BETWEEN participation_start AND participation_end') }
end
