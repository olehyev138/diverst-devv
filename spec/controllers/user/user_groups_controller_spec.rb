require 'rails_helper'

RSpec.describe User::UserGroupsController, type: :controller do

    let(:user){ create(:user) }
    let!(:user_group_one){ create(:user_group, user: user, notifications_frequency: UserGroup.notifications_frequencies[:disabled]) }
    let!(:user_group_two){ create(:user_group, user: user, notifications_frequency: UserGroup.notifications_frequencies[:disabled]) }

    describe "GET#edit" do
        context "with logged user" do
            login_user_from_let
            before { get :edit }

            it "render edit template" do
                expect(response).to render_template :edit
            end

            it "return user_groups in ascending order of group.name" do
                expect(assigns[:user_groups]).to eq UserGroup.all.joins(:group).order("groups.name").includes(:group)
            end
        end

        context "with a user not logged in" do
            before { get :edit }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "PATCH#update" do
        describe "with logged user" do
            login_user_from_let

            context "successfully" do
                before do
                    patch :update, user_groups: {
                                   "#{user_group_one.id}": { notifications_frequency: "weekly", notifications_date: "monday" },
                                   "#{user_group_two.id}": { notifications_frequency: "daily" }
                               }
                end

                it "updates the notifications_frequency of user_groups" do
                    user_group_one.reload
                    expect(user_group_one.notifications_frequency).to eq "weekly"
                    expect(user_group_one.notifications_date).to eq "monday"
                    user_group_two.reload
                    expect(user_group_two.notifications_frequency).to eq "daily"
                end

                it "flashes a notice message" do
                    expect(flash[:notice]).to eq "Your preferences were updated"
                end

                it "redirects to edit action" do
                    expect(response).to redirect_to(action: :edit)
                end
            end

            context "unsuccessfully" do
                before do
                    allow_any_instance_of(UserGroup).to receive(:update).and_return(false)
                    patch :update, user_groups: {
                                   "#{user_group_one.id}": { notifications_frequency: "hourly" },
                                   "#{user_group_two.id}": { notifications_frequency: "daily" }
                               }
                end

                it "does not update the notifications_frequency of user_groups" do
                    user_group_one.reload
                    expect(user_group_one.notifications_frequency).to_not eq "hourly"
                    user_group_two.reload
                    expect(user_group_two.notifications_frequency).to_not eq "daily"
                end

                it "flashes a notice message" do
                    expect(flash[:alert]).to eq "Your preferences were not updated. Please fix the errors"
                end

                it "redirects to edit action" do
                    expect(response).to redirect_to(action: :edit)
                end
            end
        end
    end
end
