class DoctorsController < ApplicationController
  def create
    doctor = Doctor.new(doctor_params)
    if doctor.save
      render json: doctor, status: :created
    else
      render json: { errors: doctor.errors }, status: :unprocessable_entity
    end
  end

  def balance
    doctor = Doctor.find(params[:id])
    report = doctor.balance_for_period(params[:start_date], params[:end_date])
    render json: report
  end

  private

  def doctor_params
    params.require(:doctor).permit(:name, :crm)
  end
end