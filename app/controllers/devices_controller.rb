class DevicesController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_device, only: [:update, :destroy]

  def index
    @devices = current_employee.devices
    render json: @devices
  end

  def create
    @device = current_employee.devices.new(device_params)

    if @device.save
      render json: @device
    else
      render json: @device.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @device.destroy
      render :nothing, status: 200
    else
      render json: @device.errors, status: 500
    end
  end

  protected

  def set_device
    @device = current_employee.devices.where(params[:device_id])
  end

  def device_params
    params.require(:device).permit(:platform, :token)
  end
end
