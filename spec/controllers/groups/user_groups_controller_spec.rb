require 'rails_helper'

RSpec.describe Groups::UserGroupsController, type: :controller do
  describe "PATCH#update" do
    context "with logged user" do
      let(:group){ create(:group) }
      let(:user){ create(:user) }
      let!(:user_group){ create(:user_group, user: user, group: group, enable_notification: false) }
      login_user_from_let

      context "when exists the user_group" do
        before(:each) do
          patch :update, group_id: group.id, id: user_group.id, user_group: { enable_notification: true }
        end

        it "updates the enable_notification of a user_group" do
          user_group.reload
          expect(user_group.enable_notification).to be_truthy
        end

        it "return a sucessful response" do
          expect(response.status).to eq 200
        end
      end
    end
  end
end
