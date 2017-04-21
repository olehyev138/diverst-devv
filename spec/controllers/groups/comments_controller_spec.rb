require 'rails_helper'

RSpec.describe Groups::CommentsController, type: :controller do
  let(:user) { create :user }
  let(:group){ create(:group, enterprise: user.enterprise) }
  let(:initiative){ initiative_of_group(group) }
  login_user_from_let

  describe 'POST#create' do
    let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "feedback_on_event", points: 80) }
    before(:each){ request.env["HTTP_REFERER"] = "back" }

    it "rewards a user with points of this action" do
      expect(user.points).to eq 0

      post :create, group_id: group.id, event_id: initiative.id, initiative_comment: { content: "" }

      user.reload
      expect(user.points).to eq 80
    end
  end
end
