require 'rails_helper'

RSpec.describe Groups::UserGroupsController, type: :controller do
  describe "PATCH#update" do
    context "with logged user" do
      let(:group){ create(:group) }
      let(:user){ create(:user) }
      let!(:user_group){ create(:user_group, user: user, group: group, frequency_notification: UserGroup.frequency_notifications[:disabled]) }
      login_user_from_let

      context "when exists the user_group" do
        before(:each) do
          patch :update, group_id: group.id, id: user_group.id, user_group: { frequency_notification: "real_time" }
        end

        it "updates the enable_notification of a user_group" do
          user_group.reload
          expect(user_group.frequency_notification).to eq UserGroup.frequency_notifications[:real_time]
        end

        it "return a sucessful response" do
          expect(response.status).to eq 200
        end
      end
    end
  end
end
