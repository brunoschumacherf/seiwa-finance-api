class Doctor < ApplicationRecord
  has_many :financial_events, dependent: :destroy

  validates :name, :crm, presence: true
  validates :crm, uniqueness: true
end