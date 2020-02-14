require 'rails_helper'

RSpec.describe Session::Actions, type: :model do
  describe '#logout' do
    it 'raises a BadRequestException' do
      expect { Session.logout(nil) }.to raise_error(BadRequestException)
    end

    it 'returns the logout link' do
      enterprise = create(:enterprise, has_enabled_saml: true, idp_slo_target_url: 'test')
      user = create(:user, enterprise: enterprise)
      session = create(:session, user: user)

      logout_request = OneLogin::RubySaml::Logoutrequest.new
      allow(OneLogin::RubySaml::Logoutrequest).to receive(:new).and_return(logout_request)
      allow(logout_request).to receive(:create).and_return('link')

      payload = Session.logout(UserTokenService.create_jwt_token({ user_token: session.token }))
      expect(payload[:logout_link]).to_not be nil
    end
  end
end
