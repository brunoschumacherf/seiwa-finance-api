require 'rails_helper'

RSpec.describe "Doctors", type: :request do
  describe "POST /doctors" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          doctor: {
            name: "Dr. Bruno",
            crm: "123456"
          }
        }
      end

      it "creates a new doctor" do
        expect {
          post "/doctors", params: valid_params
        }.to change(Doctor, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["name"]).to eq("Dr. Bruno")
        expect(json_response["crm"]).to eq("123456")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          doctor: {
            name: "",
            crm: ""
          }
        }
      end

      it "does not create a doctor and returns errors" do
        expect {
          post "/doctors", params: invalid_params
        }.not_to change(Doctor, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
      end
    end
  end

  describe "GET /doctors/:id/balance" do
    let!(:doctor) { create(:doctor, name: "Dr. Bruno", crm: "123456") }
    let(:start_date) { Date.today.beginning_of_month }
    let(:end_date) { Date.today.end_of_month }

    context "calculating balance correctly" do
      it "validates that productions sum and payouts subtract correctly" do
        create(:financial_event, 
               doctor: doctor, 
               event_type: :production, 
               amount: 5000.00, 
               date: Date.today,
               hospital: "Hospital A")

        create(:financial_event, 
               doctor: doctor, 
               event_type: :payout, 
               amount: 2000.00, 
               date: Date.today,
               hospital: "Hospital B")

        get "/doctors/#{doctor.id}/balance", params: {
          start_date: start_date,
          end_date: end_date
        }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response["doctor_name"]).to eq("Dr. Bruno")
        expect(json_response["crm"]).to eq("123456")
        expect(json_response["production_total"].to_f).to eq(5000.00)
        expect(json_response["payout_total"].to_f).to eq(2000.00)
        expect(json_response["net_balance"].to_f).to eq(3000.00)
      end

      it "only includes events within the date range" do
        create(:financial_event, 
               doctor: doctor, 
               event_type: :production, 
               amount: 1000.00, 
               date: start_date + 5.days)

        create(:financial_event, 
               doctor: doctor, 
               event_type: :payout, 
               amount: 500.00, 
               date: end_date - 5.days)

        create(:financial_event, 
               doctor: doctor, 
               event_type: :production, 
               amount: 9999.00, 
               date: start_date - 1.day)

        create(:financial_event, 
               doctor: doctor, 
               event_type: :payout, 
               amount: 9999.00, 
               date: end_date + 1.day)

        get "/doctors/#{doctor.id}/balance", params: {
          start_date: start_date,
          end_date: end_date
        }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response["production_total"].to_f).to eq(1000.00)
        expect(json_response["payout_total"].to_f).to eq(500.00)
        expect(json_response["net_balance"].to_f).to eq(500.00)
      end

      it "handles multiple productions and payouts correctly" do
        create(:financial_event, doctor: doctor, event_type: :production, amount: 1000.00, date: Date.today)
        create(:financial_event, doctor: doctor, event_type: :production, amount: 2000.00, date: Date.today)
        create(:financial_event, doctor: doctor, event_type: :production, amount: 1500.00, date: Date.today)

        create(:financial_event, doctor: doctor, event_type: :payout, amount: 500.00, date: Date.today)
        create(:financial_event, doctor: doctor, event_type: :payout, amount: 750.00, date: Date.today)

        get "/doctors/#{doctor.id}/balance", params: {
          start_date: start_date,
          end_date: end_date
        }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response["production_total"].to_f).to eq(4500.00)
        expect(json_response["payout_total"].to_f).to eq(1250.00)
        expect(json_response["net_balance"].to_f).to eq(3250.00)
      end
    end

    context "when doctor does not exist" do
      it "returns 404" do
        get "/doctors/99999/balance", params: {
          start_date: start_date,
          end_date: end_date
        }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
