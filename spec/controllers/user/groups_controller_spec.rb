require 'rails_helper'

RSpec.describe User::GroupsController, type: :controller do
  describe "PATCH#enable_notifications" do
    context "with logged user" do
      let(:group){ create(:group) }
      let(:user){ create(:user) }
      let!(:user_group){ create(:user_group, user: user, group: group, enable_notification: false) }
      login_user_from_let

      context "when exists the user_group" do
        before(:each){ patch :enable_notifications, id: group.id, enable_notification: true }

        it "updates the enable_notification of a user_group" do
          user_group.reload
          expect(user_group.enable_notification).to be_truthy
        end

        it "return a sucessful response" do
          expect(response.status).to eq 200
        end
      end

      context "when does not exists the user_group" do
        before(:each){ patch :enable_notifications, id: 0 }

        it "return a not_found response" do
          expect(response.status).to eq 404
        end
      end
    end
  end
end
