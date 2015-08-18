class Employees::InvitationsController < Devise::InvitationsController

  def edit
    super
    invitable.info = invitable.info.merge(params['custom-fields']) if params['custom-fields']
  end

  private

  # This prepares the resource for the invitation form
  def invite_resource
    resource_class.invite!(invite_params, current_inviter) do |invitable|
      invitable.enterprise = current_inviter.enterprise
      invitable.info = invitable.info.merge(params['custom-fields']) if params['custom-fields']
    end
  end

  # This prepares the resource for the vCard
  def accept_resource
    resource = resource_class.accept_invitation!(update_resource_params)
    resource.info = resource.info.merge(params['custom-fields']) if params['custom-fields']
    resource
  end

  def configure_permitted_parameters
    # Only add some parameters
    devise_parameter_sanitizer.for(:invite).concat [:first_name, :last_name, :email]
    devise_parameter_sanitizer.for(:accept_invitation).concat [:first_name, :last_name, :email]
  end
end