require 'rails_helper'

RSpec.describe User::DashboardController, type: :controller do
  let(:user) { create :user }


  describe 'GET #home' do
    describe 'when user is logged in' do
      login_user_from_let

      it 'renders home template' do
        get :home
        expect(response).to render_template :home
      end

      describe 'posts' do
        let(:group) { create :group, enterprise: user.enterprise }
        let(:news_feed) { create :news_feed, group: group }

        let!(:news_feed_link) { create :news_feed_link, news_feed: news_feed }
        let!(:foreign_news_feed_link) { create :news_feed_link }

        before {
          group.members << user
          group.accept_user_to_group(user.id)

          get :home
        }

        subject { assigns[:posts] }

        it 'displays items from current enterprise' do
          expect(subject).to include news_feed_link
        end

        it 'does not display items from other enterprise' do
          expect(subject).to_not include foreign_news_feed_link
        end
      end
    end

    describe 'users not logged in' do
      before { get :home }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#rewards' do
    describe 'when user is logged in' do
      login_user_from_let

      it 'render rewards template' do
        get :rewards
        expect(response).to render_template :rewards
      end

      describe 'rewards' do
        let!(:enterprise) { create(:enterprise) }
        let!(:user) { create(:user, enterprise: enterprise) }
        let!(:reward_action1) { create(:reward_action, enterprise: enterprise, points: 22) }
        let!(:reward_action2) { create(:reward_action, enterprise: enterprise, points: 5) }
        let!(:reward1) { create(:reward, enterprise: enterprise, points: 18) }
        let!(:reward2) { create(:reward, enterprise: enterprise, points: 8) }
        let!(:badge1) { create(:badge, enterprise: enterprise, points: 18) }
        let!(:badge2) { create(:badge, enterprise: enterprise, points: 8) }

        before { get :rewards }
        subject { assigns[:reward_actions] }

        it 'return reward actions for an enterprise in ascending order of points' do
          expect(subject).to eq [reward_action2, reward_action1]
        end

        it 'return rewards for an enterprise in ascending order of points' do
          expect(assigns[:rewards]).to eq [reward2, reward1]
        end

        it 'returns badges for an enterprise in ascending order of points' do
          expect(assigns[:badges]).to eq [badge2, badge1]
        end
      end
    end

    describe 'when user is not logged in' do
      before { get :rewards }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
