class FinancialEventSerializer < ActiveModel::Serializer
  attributes :id, :event_type, :amount, :date, :hospital
end
