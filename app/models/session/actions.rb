require 'securerandom'

module Session::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def logout(jwt)
      session = UserTokenService.get_session_from_jwt(jwt)
      UserTokenService.user_token_error if session.blank?

      session.update(status: 1)
      # if user enterprise has saml enabled then log out process is different
      settings = session.user.enterprise.saml_settings
      if session.user.enterprise.has_enabled_saml? && !settings.idp_slo_target_url.nil?
        logout_request = OneLogin::RubySaml::Logoutrequest.new

        if settings.name_identifier_value.nil?
          settings.name_identifier_value = session.user.email
        end

        logout_link = logout_request.create(settings, RelayState: ENV['DOMAIN'])
        return { logout_link: logout_link }
      end

      {}
    end
  end
end
