class Employees::InvitationsController < Devise::InvitationsController
  layout 'application'

  private

  # Before the vCard is sent out(right after invitation)
  def invite_resource
    resource_class.invite!(invite_params, current_inviter) do |invitable|
      invitable.enterprise = current_inviter.enterprise
      invitable.merge_info(params['custom-fields'])
      invitable.auth_source = "manual"
      invitable.save!
    end
  end

  # After the vCard is filled out and submitted
  def accept_resource
    resource = resource_class.accept_invitation!(update_resource_params)
    resource.merge_info(params['custom-fields'])

    resource.save
    resource
  end

  def configure_permitted_parameters
    # Only add some parameters
    devise_parameter_sanitizer.for(:invite).concat [:first_name, :last_name, :email]
    devise_parameter_sanitizer.for(:accept_invitation).concat [:first_name, :last_name, :email]
  end
end