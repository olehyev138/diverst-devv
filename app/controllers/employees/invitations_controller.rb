class Employees::InvitationsController < Devise::InvitationsController
  private

  def invite_resource
    resource_class.invite!(invite_params, current_inviter) do |invitable|
      invitable.enterprise = current_inviter.enterprise
    end
  end

  def configure_permitted_parameters
    # Only add some parameters
    devise_parameter_sanitizer.for(:invite).concat [:first_name, :last_name]
    devise_parameter_sanitizer.for(:accept_invitation).concat [:first_name, :last_name]
  end
end