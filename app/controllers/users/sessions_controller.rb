class Users::SessionsController < Devise::SessionsController
  include PublicActivity::StoreController

  after_filter :after_login, :only => :create

  def new
    if params[:saml_for_enterprise]
      enterprise_id = params[:saml_for_enterprise]
      redirect_to sso_enterprise_saml_index_url(enterprise_id: enterprise_id)

      return
    end

    super
  end

  def after_login
    track_activity(current_user, :login)
  end
end
