class DoctorsController < ApplicationController
  def create
    doctor = Doctor.new(doctor_params)
    if doctor.save
      render json: doctor, status: :created
    else
      render json: { errors: doctor.errors }, status: :unprocessable_entity
    end
  end

  private

  def doctor_params
    params.require(:doctor).permit(:name, :crm)
  end
end