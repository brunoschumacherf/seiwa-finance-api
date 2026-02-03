class FinancialEvent < ApplicationRecord
  belongs_to :doctor

  enum event_type: { production: 0, payout: 1 }

  validates :amount, :date, :hospital, :event_type, presence: true
  validates :amount, numericality: { greater_than: 0 }
end