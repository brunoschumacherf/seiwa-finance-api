require 'rails_helper'

RSpec.configure do |config|
  next unless defined?(Rswag)
  
  config.openapi_root = Rails.root.join('swagger').to_s

  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Seiwa Finance API V1',
        version: 'v1',
        description: 'API para gerenciamento financeiro de médicos e eventos financeiros'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ],
      components: {
        schemas: {
          Doctor: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              crm: { type: :string }
            },
            required: [:name, :crm]
          },
          FinancialEvent: {
            type: :object,
            properties: {
              id: { type: :integer },
              doctor_id: { type: :integer },
              event_type: { type: :string, enum: ['production', 'payout'] },
              amount: { type: :number, format: :float },
              date: { type: :string, format: :date },
              hospital: { type: :string }
            },
            required: [:doctor_id, :event_type, :amount, :date, :hospital]
          },
          BalanceReport: {
            type: :object,
            properties: {
              doctor_name: { type: :string },
              crm: { type: :string },
              period: {
                type: :object,
                properties: {
                  start: { type: :string, format: :date },
                  end: { type: :string, format: :date }
                }
              },
              production_total: { type: :number, format: :float },
              payout_total: { type: :number, format: :float },
              net_balance: { type: :number, format: :float }
            }
          },
          Error: {
            type: :object,
            properties: {
              errors: { type: :object }
            }
          }
        }
      }
    }
  }

  config.openapi_format = :yaml
end
