class Users::SessionsController < Devise::SessionsController
    include PublicActivity::StoreController

    after_filter :after_login, :only => :create

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

    def after_login
        track_activity(current_user, :login)
    end
end
