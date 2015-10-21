class Employees::InvitationsController < Devise::InvitationsController
  layout :resolve_layout

  protected

  def resolve_layout
    case action_name
    when "edit"
      "guest"
    else
      "global_settings"
    end
  end

  private

  # Before the vCard is sent out (right after invitation)
  def invite_resource
    resource_class.invite!(invite_params, current_inviter) do |invitable|
      invitable.enterprise = current_inviter.enterprise
      invitable.info.merge(fields: invitable.enterprise.fields, form_data: params['custom-fields'])
      invitable.auth_source = "manual"
      invitable.save!
    end
  end

  # After the vCard is filled out and submitted
  def accept_resource
    resource = resource_class.accept_invitation!(update_resource_params)
    resource.info.merge(fields: resource.enterprise.fields, form_data: params['custom-fields'])

    resource.save
    resource
  end

  def configure_permitted_parameters
    # Only add some parameters
    devise_parameter_sanitizer.for(:invite).concat [:first_name, :last_name, :email]
    devise_parameter_sanitizer.for(:accept_invitation).concat [:first_name, :last_name, :email]
  end
end