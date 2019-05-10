class Users::SessionsController < Devise::SessionsController
  include PublicActivity::StoreController
  include Onboard

  after_filter :after_login, only: :create

  def new
    if session[:saml_for_enterprise].present?
      enterprise_id = session[:saml_for_enterprise]

      enterprise = Enterprise.find_by_id(enterprise_id)

      if enterprise&.has_enabled_saml
        redirect_to sso_enterprise_saml_index_url(enterprise_id: enterprise_id)
        return
      end
    end
    super
  end

  def create
    # Determine whether this user is in the system but has not yet accepted there invitation
    resource = resource_class.find_by(email: resource_params[:email])
    if resend_invite? resource
      flash[:alert] = 'You have a pending invitation. Please check your email to accept the invitation and sign in'
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      super
    end
  end

  private

  def after_login
    track_activity(current_user, :login, { ip: current_user.current_sign_in_ip }) if current_user.present?
  end
end
