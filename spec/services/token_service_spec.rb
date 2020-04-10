require 'rails_helper'

RSpec.describe TokenService., type: :service do
  describe '#verify_jwt_token' do
    it 'verifies the user' do
      user = create(:user)
      token = UserTokenService.create_jwt user
      token_user = UserTokenService.verify_jwt_token token
      expect(token_user).to eq(user)
    end
    it 'raises an error because of a decode error' do
      expect { UserTokenService.verify_jwt_token '02032013' }.to raise_error BadRequestException
    end
    it 'raises an error because user doesnt exist' do
      user = create(:user)
      token = UserTokenService.create_jwt user
      user.reload.destroy
      expect { UserTokenService.verify_jwt_token token }.to raise_error BadRequestException
    end
  end
end
