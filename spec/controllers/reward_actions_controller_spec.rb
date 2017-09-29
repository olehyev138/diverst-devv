require 'rails_helper'

RSpec.describe RewardActionsController, type: :controller do
  let(:enterprise){ create(:enterprise) }
  let(:reward_action){ create(:reward_action, enterprise: enterprise, points: 10) }
  let(:user){ create(:user, enterprise: enterprise) }

  describe 'PATCH #update' do
    context 'with logged in user' do
      login_user_from_let

      context 'with correct params' do
        before :each do
          request.env["HTTP_REFERER"] = "index"
          patch :update, enterprise: {
            reward_actions_attributes: { "0" => { "id" => reward_action.id, "points" => 20 } }
          }
        end

        it 'updates reward_actions of an enterprise' do
          reward_action.reload
          expect(reward_action.points).to eq 20
        end

        it 'redirects to back page' do
          expect(response).to redirect_to rewards_path
        end
      end

      context 'with incorrect params' do
        before :each do
          patch :update, enterprise: {
            reward_actions_attributes: { "0" => { "id" => reward_action.id, "points" => "abc" } }
          }
        end

        it 'does not updates reward_actions of an enterprise' do
          reward_action.reload
          expect(reward_action.points).to eq 10
        end

        it 'render edit template' do
          expect(response).to render_template "rewards/index"
        end
      end
    end
  end
end
