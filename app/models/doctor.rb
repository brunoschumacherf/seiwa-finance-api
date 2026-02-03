class Doctor < ApplicationRecord
  has_many :financial_events, dependent: :destroy

  validates :name, :crm, presence: true
  validates :crm, uniqueness: true

  def balance_for_period(start_date, end_date)
    events = financial_events.where(date: start_date..end_date)
    
    production_total = events.production.sum(:amount)
    payout_total = events.payout.sum(:amount)
    
    {
        doctor_name: name,
        crm: crm,
        period: { start: start_date, end: end_date },
        production_total: production_total,
        payout_total: payout_total,
        net_balance: production_total - payout_total
    }
  end
end