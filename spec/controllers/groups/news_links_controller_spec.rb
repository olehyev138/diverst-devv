require 'rails_helper'

RSpec.describe Groups::NewsLinksController, type: :controller do
  let(:user) { create :user }
  let(:group){ create(:group, enterprise: user.enterprise) }
  login_user_from_let

  describe 'GET #index' do
    def get_index(group_id)
      get :index, group_id: group_id
    end

    let!(:news_link) { create(:news_link, group: group) }
    let!(:foregin_news_link) { create(:news_link) }

    context 'with logged user' do
      login_user_from_let

      before { get_index(group.to_param) }

      it 'return success' do
        expect(response).to be_success
      end

      it 'assigns correct newslinks' do
        news_links = assigns(:news_links)

        expect(news_links).to include news_link
        expect(news_links).to_not include foregin_news_link
      end
    end

    context 'without logged user' do
      before { get_index(group.to_param) }

      xit 'return error' do
        expect(response).to redirect_to action: :index
      end
    end
  end

  describe 'POST#create' do
    let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "news_post", points: 30) }

    it "rewards a user with points of this action" do
      expect(user.points).to eq 0

      post :create, group_id: group.id, news_link: attributes_for(:news_link)

      user.reload
      expect(user.points).to eq 30
    end

    it "send group notification to users" do
      expect(UserGroupInstantNotificationJob).to receive(:perform_later).with(group, news_count: 1)
      post :create, group_id: group.id, news_link: attributes_for(:news_link)
    end
  end

  describe 'POST#create_comment' do
    let!(:news_link){ create(:news_link, group: group) }
    let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "news_comment", points: 35) }

    it "rewards a user with points of this action" do
      expect(user.points).to eq 0

      post :create_comment, group_id: group.id, id: news_link, news_link_comment: attributes_for(:news_link)

      user.reload
      expect(user.points).to eq 35
    end
  end

  describe 'DELETE#destroy' do
    let!(:news_link){ create(:news_link, group: group) }
    let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "news_post", points: 90) }
    before :each do
      Rewards::Points::Manager.new(user, reward_action.key).add_points(news_link)
    end

    it "remove reward points of a user with points of this action" do
      expect(user.points).to eq 90

      delete :destroy, group_id: group.id, id: news_link.id

      user.reload
      expect(user.points).to eq 0
    end
  end
end
