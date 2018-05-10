class Users::PasswordsController < Devise::PasswordsController
  # This was overwritten to:
  # 1) Behave the same way for correct and incorrect emails
  #    to prevent brute force username lookup
  #    POST /resource/password
  #
  # 2) Resend an invite email for invited but not accepted users
  #

  def create
    self.resource = resource_class.find_by(email: resource_params[:email])
    message = ''

    if resend_invite?
      # Resend invite
      resource_class.invite!(email: resource.email)
      message = 'You have a pending invitation. Please check your email to accept the invitation and sign in'
    else
      # Send reset password instructions
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      message = 'You will recieve an email shortly'
    end

    yield resource if block_given?

    flash[:notice] = message
    respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
  end

  private

  def resend_invite?
    # Determine whether this user is in the system but has not yet accepted there invitation
    self.resource != nil and self.resource.invitation_accepted_at == nil
  end
end
