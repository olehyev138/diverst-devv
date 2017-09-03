require 'rails_helper'

RSpec.describe User::UserGroupsController, type: :controller do
    
    let(:user){ create(:user) }
    let!(:user_group_one){ create(:user_group, user: user, notifications_frequency: UserGroup.notifications_frequencies[:disabled]) }
    let!(:user_group_two){ create(:user_group, user: user, notifications_frequency: UserGroup.notifications_frequencies[:disabled]) }
    login_user_from_let
    
    describe "GET#edit" do
        context "with logged user" do
            it "edits the user groups" do
                get :edit
                expect(response).to be_success
            end
        end
    end
    
    describe "PATCH#update" do
        context "with logged user" do

            before(:each) do
                patch :update, user_groups: {
                                   "#{user_group_one.id}": { notifications_frequency: "real_time" },
                                   "#{user_group_two.id}": { notifications_frequency: "daily" }
                               }
            end

            it "updates the notifications_frequency of user_groups" do
                user_group_one.reload
                expect(user_group_one.notifications_frequency).to eq "real_time"
                user_group_two.reload
                expect(user_group_two.notifications_frequency).to eq "daily"
            end
        end
    end
end
