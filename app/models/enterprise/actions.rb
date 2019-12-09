require 'securerandom'

module Enterprise::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preload
      [ :theme ]
    end

    def sso_login(diverst_request, params)
      enterprise = find(params[:id])
      settings = enterprise.saml_settings
      response = OneLogin::RubySaml::Response.new(params[:SAMLResponse], settings: settings)

      if response.is_valid?
        nameid = response.nameid
        attrs = response.attributes

        unless user = enterprise.users.find_by_email(nameid)
          user = enterprise.users.new(auth_source: 'saml', enterprise: enterprise)
          user.user_role_id = enterprise.default_user_role
          user.set_info_from_saml(nameid, attrs, enterprise)

          enterprise.users << user
          enterprise.save!
        end

        user.set_info_from_saml(nameid, attrs, enterprise)

        "#{ENV['DOMAIN']}/login?userToken=#{UserTokenService.create_jwt(user, params)}&policyGroupId=#{user.policy_group.id}"
      else
        "#{ENV['DOMAIN']}/login?errorMessage=#{response.errors.first}"
      end
    end

    def sso_link(diverst_request, params)
      item = find(params[:id])
      settings = item.saml_settings
      request = OneLogin::RubySaml::Authrequest.new
      request.create(settings, RelayState: params[:relay_state])
    end
  end
end
