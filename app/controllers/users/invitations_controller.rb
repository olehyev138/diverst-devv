class Users::InvitationsController < Devise::InvitationsController
  layout :resolve_layout
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_policy, only: [:new]

  protected

  def resolve_layout
    case action_name
    when 'edit'
      false # No layout since we have no logged in user and the themes require one in the layout
    else
      'global_settings'
    end
  end

  protected

  # Before the vCard is sent out (right after invitation)
  def invite_resource
    resource_class.invite!(invite_params, current_inviter) do |invitable|
      invitable.enterprise = current_inviter.enterprise
      invitable.info.merge(fields: invitable.enterprise.fields, form_data: params['custom-fields'])
      invitable.auth_source = 'manual'
      invitable.save
    end
  end

  # After the vCard is filled out and submitted
  def accept_resource
    resource = resource_class.accept_invitation!(update_resource_params)
    resource.info.merge(fields: resource.enterprise.fields, form_data: params['custom-fields'])
    resource.policy_group = resource.enterprise.default_policy_group

    resource.save
    resource
  end

  def configure_permitted_parameters
    # Only add some parameters
    devise_parameter_sanitizer.for(:invite).concat [:first_name, :last_name, :email, group_ids: []]
    devise_parameter_sanitizer.for(:accept_invitation).concat [:first_name, :last_name, group_ids: []]
  end

  def ensure_policy
    authorize User, :new?
  end
end
