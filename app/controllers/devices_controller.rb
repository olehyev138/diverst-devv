class DevicesController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_employee!
  before_action :set_device, only: [:update, :test_notif]
  serialization_scope :current_employee

  APN = Houston::Client.development

  def index
    @devices = current_employee.devices
    render json: @devices
  end

  def create
    # Prevent from adding duplicates
    devices_with_token = current_employee.devices.where(token: device_params[:token])
    if devices_with_token.size > 0
      return render json: devices_with_token.first
    end

    @device = current_employee.devices.new(device_params)

    if @device.save
      render json: @device
    else
      render json: @device.errors, status: :unprocessable_entity
    end
  end

  # Delete a device by its push token
  def destroy
    device = current_employee.devices.where(token: params[:id]).first
    not_found! if device.nil?

    if device.destroy
      head :no_content
    else
      render json: @device.errors, status: 500
    end
  end

  def test_notif
    if @device.platform == "apple"
      APN.certificate = ENV["APN_CERT"]

      # An example of the token sent back when a device registers for notifications
      token = @device.token

      # Create a notification that alerts a message to the user, plays a sound, and sets the badge on the app
      notification = Houston::Notification.new(device: token)
      notification.alert = "Hello, World!"

      # Notifications can also change the badge count, have a custom sound, have a category identifier, indicate available Newsstand content, or pass along arbitrary data.
      notification.badge = 5
      notification.sound = "sosumi.aiff"
      notification.category = "INVITE_CATEGORY"
      notification.custom_data = {foo: "bar"}

      # And... sent! That's all it takes.
      APN.push(notification)

      if notification.error
        render json: { message: notification.error }, status: 500
      else
        head :no_content
      end
    elsif @device.platform == "android"
      gcm = GCM.new(ENV["GCM_KEY"])

      registration_ids = [@device.token] # an array of one or more client registration IDs
      options = {data: {score: "123"}, collapse_key: "updated_score"}
      response = gcm.send(registration_ids, options)
    end
  end

  protected

  def set_device
    @device = current_employee.devices.find(params[:id])
  end

  def device_params
    params.require(:device).permit(:platform, :token)
  end
end
