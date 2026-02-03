require 'swagger_helper'

if defined?(Rswag)
  RSpec.describe 'Doctors API', type: :request do
    path '/doctors' do
      post 'Creates a doctor' do
        tags 'Doctors'
        consumes 'application/json'
        produces 'application/json'
        parameter name: :doctor, in: :body, schema: {
          type: :object,
          properties: {
            doctor: {
              type: :object,
              properties: {
                name: { type: :string, example: 'Dr. Bruno' },
                crm: { type: :string, example: '123456' }
              },
              required: [:name, :crm]
            }
          }
        }

        response '201', 'doctor created' do
          schema type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              crm: { type: :string }
            },
            required: ['id', 'name', 'crm']

          let(:doctor) { { doctor: { name: 'Dr. Bruno', crm: '123456' } } }
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['name']).to eq('Dr. Bruno')
            expect(data['crm']).to eq('123456')
          end
        end

        response '422', 'invalid request' do
          schema '$ref' => '#/components/schemas/Error'
          let(:doctor) { { doctor: { name: '', crm: '' } } }
          run_test!
        end
      end
    end

    path '/doctors/{id}/balance' do
      get 'Gets doctor balance for a period' do
        tags 'Doctors'
        produces 'application/json'
        parameter name: :id, in: :path, type: :integer, required: true, description: 'Doctor ID'
        parameter name: :start_date, in: :query, type: :string, format: :date, required: true, 
                   description: 'Start date (YYYY-MM-DD)', example: '2024-01-01'
        parameter name: :end_date, in: :query, type: :string, format: :date, required: true,
                   description: 'End date (YYYY-MM-DD)', example: '2024-01-31'

        response '200', 'balance retrieved' do
          schema '$ref' => '#/components/schemas/BalanceReport'

          let(:doctor) { create(:doctor, name: 'Dr. Bruno', crm: '123456') }
          let(:id) { doctor.id }
          let(:start_date) { Date.today.beginning_of_month.to_s }
          let(:end_date) { Date.today.end_of_month.to_s }

          before do
            create(:financial_event, 
                   doctor: doctor, 
                   event_type: :production, 
                   amount: 5000.00, 
                   date: Date.today)
            create(:financial_event, 
                   doctor: doctor, 
                   event_type: :payout, 
                   amount: 2000.00, 
                   date: Date.today)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['doctor_name']).to eq('Dr. Bruno')
            expect(data['production_total']).to eq(5000.00)
            expect(data['payout_total']).to eq(2000.00)
            expect(data['net_balance']).to eq(3000.00)
          end
        end

        response '404', 'doctor not found' do
          schema '$ref' => '#/components/schemas/Error'
          let(:id) { 99999 }
          let(:start_date) { Date.today.beginning_of_month.to_s }
          let(:end_date) { Date.today.end_of_month.to_s }
          run_test!
        end
      end
    end
  end
end
