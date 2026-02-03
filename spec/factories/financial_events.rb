FactoryBot.define do
  factory :financial_event do
    association :doctor
    event_type { :production }
    amount { 1000.00 }
    date { Date.today }
    hospital { "Hospital Teste" }

    trait :production do
      event_type { :production }
    end

    trait :payout do
      event_type { :payout }
    end
  end
end
