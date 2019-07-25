class Users::InvitationsController < Devise::InvitationsController
  layout :resolve_layout
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_policy, only: [:new]

  def index
    redirect_to user_root_path
  end

  protected

  def resolve_layout
    case action_name
    when 'edit'
      false # No layout since wef.hi have no logged in user and the themes require one in the layout
    else
      'global_settings'
    end
  end

  protected

  # Before the vCard is sent out (right after invitation)
  def invite_resource
    resource_class.invite!(invite_params, current_inviter) do |invitable|
      invitable.skip_invitation = !current_inviter.enterprise.has_enabled_onboarding_email
      invitable.enterprise = current_inviter.enterprise
      invitable.info.merge(fields: invitable.enterprise.fields, form_data: params['custom-fields'])
      invitable.auth_source = 'manual'
      invitable.save
      track_activity(invitable, :create) # user create action
    end
  end

  def after_invite_path_for(resource)
    flash[:notice] = 'Invitation has been sent'
    users_path
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
    devise_parameter_sanitizer.for(:invite).concat [:first_name, :last_name, :email, :role, group_ids: []]
    devise_parameter_sanitizer.for(:accept_invitation).concat [:first_name, :last_name, :seen_onboarding, group_ids: []]
  end

  def ensure_policy
    authorize User, :new?
  end
end
