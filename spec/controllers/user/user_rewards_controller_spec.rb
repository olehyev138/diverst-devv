require 'rails_helper'

RSpec.describe User::UserRewardsController, type: :controller do
  let(:user) { create :user }
  let(:reward) { create(:reward, enterprise: user.enterprise, points: 10) }

  describe 'POST#create' do
    describe 'with a logged in user' do
      login_user_from_let

      context 'with user without credits' do
        it 'should redirect to error action' do
          post :create, reward_id: reward

          expect(response).to redirect_to action: :error
        end
      end

      context 'with user with credits' do
        it 'should redirect to success action' do
          create(:user_reward_action, user: user, operation: 'add', points: 20)

          post :create, reward_id: reward

          expect(response).to redirect_to action: :success
        end
      end
    end

    describe 'with a user not logged in' do
      before { post :create, reward_id: reward }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#approve_reward' do
    let(:pending_reward) { create(:user_reward, status: 0,
                                                points: 10,
                                                user_id: user.id,
                                                reward_id: reward.id)
    }

    describe 'with a logged in user' do
      login_user_from_let

      context 'with pending user_reward' do
        before do
          allow(RewardMailerJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = 'back'
          patch :approve_reward, reward_id: reward.id, id: pending_reward.id
        end

        it 'approves reward redemption' do
          expect(pending_reward.reload.status.redeemed?).to eq(true)
        end

        it 'flashes a notice message' do
          message = "#{pending_reward.user.name}'s reward has been redeemed!"
          expect(flash[:notice]).to eq(message)
        end

        it 'reward mailer sent via RewardMailerJob' do
          expect(RewardMailerJob).to have_received(:perform_later)
        end

        it 'redirects back' do
          expect(response).to redirect_to 'back'
        end
      end
    end

    describe 'with a user not logged in' do
      before { patch :approve_reward, reward_id: reward.id, id: pending_reward.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#reward_to_be_forfeited' do
    let(:pending_reward) { create(:user_reward, status: 0,
                                                points: 10,
                                                user_id: user.id,
                                                reward_id: reward.id)
    }

    describe 'with a logged in user' do
      login_user_from_let

      context 'with pending user_reward' do
        before { xhr :get, :reward_to_be_forfeited, reward_id: reward.id, id: pending_reward.id }

        it 'render template reward_to_be_forfeited' do
          expect(response).to render_template :reward_to_be_forfeited
        end

        it 'return user_reward' do
          expect(assigns[:user_reward]).to eq(pending_reward)
        end
      end
    end
  end

  describe 'PATCH#forfeit_reward' do
    let(:pending_reward) { create(:user_reward, status: 0,
                                                points: 10,
                                                user_id: user.id,
                                                reward_id: reward.id)
    }

    describe 'with a logged in user' do
      login_user_from_let

      context 'with pending_reward' do
        before do
          allow(RewardMailerJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = 'back'
          patch :forfeit_reward, reward_id: reward.id, id: pending_reward.id, user_reward: { comment: 'not qualified for this reward' }
        end

        it 'forfeit user_reward' do
          expect(pending_reward.reload.status.forfeited?).to eq(true)
        end

        it 'calls RewardMailerJob' do
          expect(RewardMailerJob).to have_received(:perform_later)
        end

        it 'display flash notice message' do
          expect(flash[:notice]).to eq("#{user.name}'s reward has been forfeited!")
        end

        it 'redirects back' do
          expect(response).to redirect_to 'back'
        end
      end
    end
  end
end
