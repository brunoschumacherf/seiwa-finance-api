class FinancialEventsController < ApplicationController
  def create
    event = FinancialEvent.new(event_params)
    if event.save
      render json: event, status: :created
    else
      render json: { errors: event.errors }, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:financial_event).permit(:doctor_id, :event_type, :amount, :date, :hospital)
  end
end