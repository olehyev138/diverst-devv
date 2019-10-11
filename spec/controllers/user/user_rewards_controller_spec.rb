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

  describe 'DELETE#destroy' do
    let!(:pending_reward) { create(:user_reward, status: 0,
                                                 points: 10,
                                                 user_id: user.id,
                                                 reward_id: reward.id)
    }

    describe 'with a logged in user' do
      login_user_from_let

      context 'destroy user reward' do
        before { request.env['HTTP_REFERER'] = 'back' }

        it 'successfully' do
          expect { delete :destroy, reward_id: reward.id, id: pending_reward.id
          }.to change(UserReward, :count).by(-1)
        end

        it 'flashes notice message' do
          message = "#{pending_reward.user.name}'s reward has been forfeited!"
          delete :destroy, reward_id: reward.id, id: pending_reward.id

          expect(flash[:notice]).to eq(message)
        end

        it 'redirects to back' do
          delete :destroy, reward_id: reward.id, id: pending_reward.id

          expect(response).to redirect_to 'back'
        end
      end
    end

    describe 'with a user not logged in' do
      before { delete :destroy, reward_id: reward.id, id: pending_reward.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
