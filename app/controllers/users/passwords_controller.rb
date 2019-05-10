class Users::PasswordsController < Devise::PasswordsController
  # This was overwritten to:
  # 1) Behave the same way for correct and incorrect emails
  #    to prevent brute force username lookup
  #    POST /resource/password
  #
  # 2) Resend an invite email for invited but not accepted users
  #

  include Onboard

  # GET /resource/password/new
  def new
    self.resource = resource_class.new

    if params[:setup]
      render :setup
    else
      render :new
    end
  end

  def create
    self.resource = resource_class.find_by(email: resource_params[:email])
    message = ''

    if resend_invite? self.resource
      # Resend invite
      resource_class.invite!(email: resource.email)
      message = 'You will recieve an email shortly. Please check your email to accept the invitation and sign in'
    else
      # Send reset password instructions
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      message = 'You will recieve an email shortly'
    end

    yield resource if block_given?

    flash[:notice] = message
    respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
  end
end
