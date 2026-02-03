require 'rails_helper'

RSpec.describe "FinancialEvents", type: :request do
  let!(:doctor) { create(:doctor) }

  describe "POST /financial_events" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          financial_event: {
            doctor_id: doctor.id,
            event_type: "production",
            amount: 1000.00,
            date: Date.today,
            hospital: "Hospital Teste"
          }
        }
      end

      it "creates a new financial event" do
        expect {
          post "/financial_events", params: valid_params
        }.to change(FinancialEvent, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["event_type"]).to eq("production")
        expect(json_response["amount"]).to eq("1000.0")
        expect(json_response["hospital"]).to eq("Hospital Teste")
      end

      it "creates a payout event" do
        payout_params = valid_params.deep_dup
        payout_params[:financial_event][:event_type] = "payout"
        payout_params[:financial_event][:amount] = 500.00

        expect {
          post "/financial_events", params: payout_params
        }.to change(FinancialEvent, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["event_type"]).to eq("payout")
        expect(json_response["amount"]).to eq("500.0")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          financial_event: {
            doctor_id: doctor.id,
            event_type: "",
            amount: -100,
            date: nil,
            hospital: ""
          }
        }
      end

      it "does not create a financial event and returns errors" do
        expect {
          post "/financial_events", params: invalid_params
        }.not_to change(FinancialEvent, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
      end
    end

    context "with invalid doctor_id" do
      let(:invalid_doctor_params) do
        {
          financial_event: {
            doctor_id: 99999,
            event_type: "production",
            amount: 1000.00,
            date: Date.today,
            hospital: "Hospital Teste"
          }
        }
      end

      it "does not create a financial event" do
        expect {
          post "/financial_events", params: invalid_doctor_params
        }.not_to change(FinancialEvent, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
