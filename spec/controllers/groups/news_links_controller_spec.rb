require 'rails_helper'

RSpec.describe Groups::NewsLinksController, type: :controller do
  let(:user) { create :user }
  let(:group){ create(:group, enterprise: user.enterprise) }
  login_user_from_let

  describe 'POST#create' do
    let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "news_post", points: 30) }

    it "rewards a user with points of this action" do
      expect(user.points).to eq 0

      post :create, group_id: group.id, news_link: attributes_for(:news_link)

      user.reload
      expect(user.points).to eq 30
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
