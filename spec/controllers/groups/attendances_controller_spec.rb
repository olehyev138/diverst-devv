require 'rails_helper'

RSpec.describe Groups::AttendancesController, type: :controller do
  let(:user) { create :user }
  let(:group){ create(:group, enterprise: user.enterprise) }
  let(:initiative){ initiative_of_group(group) }
  login_user_from_let

  describe 'POST#create' do
    let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "attend_event", points: 90) }

    it "rewards a user with points of this action" do
      expect(user.points).to eq 0

      post :create, group_id: group.id, event_id: initiative.id

      user.reload
      expect(user.points).to eq 90
    end
  end

  describe 'DELETE#destroy' do
    let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "attend_event", points: 90) }
    before :each do
      create(:initiative_user, initiative: initiative, user: user)
      Rewards::Points::Manager.new(user, reward_action.key).add_points(initiative)
    end

    it "remove reward points of a user with points of this action" do
      expect(user.points).to eq 90

      delete :destroy, group_id: group.id, event_id: initiative.id

      user.reload
      expect(user.points).to eq 0
    end
  end
end
