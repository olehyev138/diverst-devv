require 'securerandom'

module Session::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def destroy(diverst_request, params)
      session = Session.find_by_token(params[:id])
      if session.nil?
        raise BadRequestException.new 'Invalid user Token'
      else
        session.update(status: 1)
        # if user enterprise has saml enabled then log out process is different
        settings = session.user.enterprise.saml_settings
        if session.user.enterprise.has_enabled_saml? && !settings.idp_slo_target_url.nil?
          logout_request = OneLogin::RubySaml::Logoutrequest.new

          if settings.name_identifier_value.nil?
            settings.name_identifier_value = session.user.email
          end

          logout_link = logout_request.create(settings, RelayState: ENV['DOMAIN'])
          { token: params[:id], logout_link: logout_link }
        else
          { token: params[:id] }
        end
      end
    end
  end
end
