require 'rails_helper'

RSpec.describe PasswordResetTokenService, type: :service do
  describe '#verify_jwt_token' do
    let(:user) { create(:user) }
    context 'request token' do
      let(:token) { PasswordResetTokenService.request_token(user) }
      context 'user is not found' do
        before do
          allow(PasswordResetTokenService).to receive(:get_payload_from_jwt)
                                                  .and_return([nil, {}])
        end

        it 'raises and error' do
          expect { PasswordResetTokenService.verify_jwt_token token, 'reset_password' }
              .to raise_error(BadRequestException, 'Invalid Password Reset Link')
        end
      end

      context 'wrong type of token' do
        before do
          allow(PasswordResetTokenService).to receive(:get_payload_from_jwt)
                                                  .and_return([user, { 'user_id' => user.id, 'type' => 'set_new_password' }])
        end

        it 'raises and error' do
          expect { PasswordResetTokenService.verify_jwt_token token, 'reset_password' }
              .to raise_error(BadRequestException, 'Invalid Token')
        end
      end

      context 'invitation expired' do
        before do
          allow(PasswordResetTokenService).to receive(:get_payload_from_jwt)
                                                  .and_return([user, { 'user_id' => user.id, 'type' => 'reset_password', 'created' => (InviteTokenService::TOKEN_EXPIRATION + 1.hour).ago }])
        end

        it 'raises and error' do
          expect { PasswordResetTokenService.verify_jwt_token token, 'reset_password' }
              .to raise_error(BadRequestException, 'Token Expired')
        end
      end

      context 'valid_token' do
        it 'returns the correct user' do
          expect(PasswordResetTokenService.verify_jwt_token(token, 'reset_password').id).to eq(user.id)
        end
      end

      context 'invalid tokens' do
        it 'raises an error because of a decode error' do
          expect { PasswordResetTokenService.verify_jwt_token '02032013', 'reset_password' }.to raise_error BadRequestException
        end

        it 'raises an error because user doesnt exist' do
          user = create(:user)
          token = PasswordResetTokenService.request_token user
          user.reload.destroy
          expect { PasswordResetTokenService.verify_jwt_token token, 'reset_password' }.to raise_error BadRequestException
        end
      end
    end

    context 'form token' do
      let(:token_user) { PasswordResetTokenService.form_token(PasswordResetTokenService.request_token(user)) }
      let(:token) { token_user.first }
      let(:reset_password_user) { token_user.second }
      context 'valid_token' do
        it 'returns the correct user' do
          expect(PasswordResetTokenService.verify_jwt_token(token, 'set_new_password').id).to eq(user.id)
        end
      end

      context 'invalid tokens' do
        it 'raises an error because of a decode error' do
          expect { PasswordResetTokenService.verify_jwt_token '02032013', 'set_new_password' }.to raise_error BadRequestException
        end

        it 'raises an error because user doesnt exist' do
          user = create(:user)
          token = PasswordResetTokenService.request_token user
          user.reload.destroy
          expect { PasswordResetTokenService.verify_jwt_token token, 'set_new_password' }.to raise_error BadRequestException
        end
      end
    end
  end
end
