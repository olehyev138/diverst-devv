require 'rails_helper'

RSpec.describe InviteTokenService, type: :service do
  describe '#verify_jwt_token' do
    let(:user) { create(:user) }
    context 'request token' do
      let(:token) { InviteTokenService.request_token(user) }
      context 'user is not found' do
        before do
          allow(InviteTokenService).to receive(:get_payload_from_jwt)
                                           .and_return([nil, {}])
        end

        it 'raises and error' do
          expect { InviteTokenService.verify_jwt_token token, 'invite' }
              .to raise_error(BadRequestException, 'Invalid Invitation Link')
        end
      end

      context 'wrong type of token' do
        before do
          allow(InviteTokenService).to receive(:get_payload_from_jwt)
                                           .and_return([user, {'user_id' => user.id, 'type' => 'set_password'}])
        end

        it 'raises and error' do
          expect { InviteTokenService.verify_jwt_token token, 'invite' }
              .to raise_error(BadRequestException, 'Invalid Token')
        end
      end

      context 'invitation expired' do
        before do
          allow_any_instance_of(User).to receive(:invitation_created_at)
                                             .and_return((InviteTokenService::TOKEN_EXPIRATION + 1.hour).ago)
        end

        it 'raises and error' do
          expect { InviteTokenService.verify_jwt_token token, 'invite' }
              .to raise_error(BadRequestException, 'Invitation Expired')
        end
      end

      context 'valid_token' do
        it 'returns the correct user' do
          expect(InviteTokenService.verify_jwt_token(token, 'invite').id).to eq(user.id)
        end
      end

      context 'invalid tokens' do
        it 'raises an error because of a decode error' do
          expect { InviteTokenService.verify_jwt_token '02032013', 'invite' }.to raise_error BadRequestException
        end

        it 'raises an error because user doesnt exist' do
          user = create(:user)
          token = InviteTokenService.request_token user
          user.reload.destroy
          expect { InviteTokenService.verify_jwt_token token, 'invite' }.to raise_error BadRequestException
        end
      end
    end

    context 'form token' do
      let(:token_user) { InviteTokenService.form_token(InviteTokenService.request_token(user)) }
      let(:token) { token_user.first }
      let(:invite_user) { token_user.second }
      context 'valid_token' do
        it 'returns the correct user' do
          expect(InviteTokenService.verify_jwt_token(token, 'set_password').id).to eq(user.id)
        end
      end

      context 'invalid tokens' do
        it 'raises an error because of a decode error' do
          expect { InviteTokenService.verify_jwt_token '02032013', 'set_password' }.to raise_error BadRequestException
        end

        it 'raises an error because user doesnt exist' do
          user = create(:user)
          token = InviteTokenService.request_token user
          user.reload.destroy
          expect { InviteTokenService.verify_jwt_token token, 'set_password' }.to raise_error BadRequestException
        end
      end
    end
  end
end
