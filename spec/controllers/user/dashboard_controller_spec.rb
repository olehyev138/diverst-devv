require 'rails_helper'

RSpec.describe User::DashboardController, type: :controller do
  let(:user) { create :user }

  login_user_from_let

  describe 'GET #home' do
    it "returns success" do
      get :home
      expect(response).to be_success
    end

    describe 'posts' do
      let(:group) { create :group, enterprise: user.enterprise }
      let(:news_feed) { create :news_feed, group: group }

      let!(:news_feed_link) { create :news_feed_link, news_feed: news_feed}
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

  describe 'GET #rewards' do
    it "returns success" do
      get :rewards
      expect(response).to be_success
    end
  end
end
