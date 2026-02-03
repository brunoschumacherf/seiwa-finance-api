require 'swagger_helper'

if defined?(Rswag)
  RSpec.describe 'Financial Events API', type: :request do
    path '/financial_events' do
      post 'Creates a financial event' do
        tags 'Financial Events'
        consumes 'application/json'
        produces 'application/json'
        parameter name: :financial_event, in: :body, schema: {
          type: :object,
          properties: {
            financial_event: {
              type: :object,
              properties: {
                doctor_id: { type: :integer, example: 1 },
                event_type: { type: :string, enum: ['production', 'payout'], example: 'production' },
                amount: { type: :number, format: :float, example: 1000.00 },
                date: { type: :string, format: :date, example: '2024-01-15' },
                hospital: { type: :string, example: 'Hospital Teste' }
              },
              required: [:doctor_id, :event_type, :amount, :date, :hospital]
            }
          }
        }

        response '201', 'financial event created' do
          schema '$ref' => '#/components/schemas/FinancialEvent'

          let(:doctor) { create(:doctor) }
          let(:financial_event) do
            {
              financial_event: {
                doctor_id: doctor.id,
                event_type: 'production',
                amount: 1000.00,
                date: Date.today.to_s,
                hospital: 'Hospital Teste'
              }
            }
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['event_type']).to eq('production')
            expect(data['amount']).to be_present
          end
        end

        response '201', 'payout event created' do
          schema '$ref' => '#/components/schemas/FinancialEvent'

          let(:doctor) { create(:doctor) }
          let(:financial_event) do
            {
              financial_event: {
                doctor_id: doctor.id,
                event_type: 'payout',
                amount: 500.00,
                date: Date.today.to_s,
                hospital: 'Hospital Teste'
              }
            }
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['event_type']).to eq('payout')
          end
        end

        response '422', 'invalid request' do
          schema '$ref' => '#/components/schemas/Error'
          let(:doctor) { create(:doctor) }
          let(:financial_event) do
            {
              financial_event: {
                doctor_id: doctor.id,
                event_type: '',
                amount: -100,
                date: nil,
                hospital: ''
              }
            }
          end
          run_test!
        end
      end
    end
  end
end
