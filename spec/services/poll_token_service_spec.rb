require 'rails_helper'

RSpec.describe PollTokenService, type: :service do
  describe '#verify_jwt_token' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group) { create(:group, enterprise: enterprise) }
    let!(:user) { create(:user, enterprise: enterprise) }
    let!(:user_group) { create(:user_group, user: user, group: group) }
    let!(:poll) { create(:poll, group_ids: [group.id], enterprise: enterprise) }
    let!(:poll_token) { poll.user_poll_tokens.create(user_id: 1) }

    context 'email token' do
      let(:token) { PollTokenService.email_jwt_token(poll_token) }

      context 'poll_token not found' do
        before do
          allow(PollTokenService).to receive(:get_payload_from_jwt)
                                           .and_return([nil, {}])
        end
        it 'raises and error' do
          expect { PollTokenService.verify_jwt_token token, 'response' }
              .to raise_error(BadRequestException, 'Invalid Poll Token')
        end
      end

      context 'poll_token cancelled' do
        before do
          allow_any_instance_of(UserPollToken).to receive(:cancelled?)
                                           .and_return(true)
        end
        it 'raises and error' do
          expect { PollTokenService.verify_jwt_token token, 'response' }
              .to raise_error(BadRequestException, 'Invalid Poll Token')
        end
      end

      context 'already responded' do
        before do
          allow_any_instance_of(UserPollToken).to receive(:submitted?)
                                           .and_return(true)
        end
        it 'raises and error' do
          expect { PollTokenService.verify_jwt_token token, 'response' }
              .to raise_error(BadRequestException, 'User Already Answered')
        end
      end

      context 'valid_token' do
        it 'returns the correct poll_token' do
          expect(PollTokenService.verify_jwt_token(token, 'first').id).to eq(poll_token.id)
        end
      end

      context 'invalid tokens' do
        it 'raises an error because of a decode error' do
          expect { PollTokenService.verify_jwt_token '02032013', 'first' }.to raise_error BadRequestException
        end
      end
    end

    context 'form token' do
      let(:token_and_submission) { PollTokenService.submission_jwt_token(PollTokenService.email_jwt_token(poll_token)) }
      let(:token) { token_and_submission.first }
      let(:submission) { token_and_submission.second }

      context 'valid_token' do
        it 'returns the correct user' do
          expect(PollTokenService.verify_jwt_token(token, 'response').id).to eq(poll_token.id)
        end
      end

      context 'invalid tokens' do
        it 'raises an error because of a decode error' do
          expect { PollTokenService.verify_jwt_token '02032013', 'response' }.to raise_error BadRequestException
        end
      end
    end
  end
end
