require 'rails_helper'

RSpec.describe Groups::GroupMembersController, type: :controller do
    let(:user) { create :user }
    let(:add) { create :user }
    let(:group){ create(:group, enterprise: user.enterprise) }
    let(:user_group) {create(:user_group, group_id: group.id, user_id: user.id)}

    describe 'GET#index' do
        login_user_from_let

        it "gets the members" do
            get :index, group_id: group.id
            expect(response).to be_success
        end
    end

    describe 'GET#pending' do
        login_user_from_let

        it "gets the pending members" do
            get :pending, group_id: group.id
            expect(response).to be_success
        end
    end

    describe 'POST#accept_pending' do
        describe "with logged in user" do
            login_user_from_let

            before { user_group.save }

            it "accepts the pending member" do
                post :accept_pending, group_id: group.id, id: user.id
                expect(response).to redirect_to action: :pending
            end

            context 'public activity' do
                enable_public_activity

                it 'creates public activity record' do
                    expect{ post :accept_pending, group_id: group.id, id: user.id
                     }.to change(PublicActivity::Activity, :count).by(1)
                end

                describe 'activity record' do
                    let(:model) { User.last }
                    let(:owner) { user }
                    let(:key) { 'user.accept_pending' }

                    before {
                      post :accept_pending, group_id: group.id, id: user.id
                  }
                  include_examples'correct public activity'
                end
            end
        end

        describe "without logged in user" do
            before { post :accept_pending, group_id: group.id, id: user.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe 'GET#new' do
        login_user_from_let

        it "get new member object" do
            get :new, group_id: group.id
            expect(response).to be_success
        end
    end

    describe 'DELETE#destroy' do
        login_user_from_let

        context "before removing" do
            it "makes sure group count is 1" do
                user_group.save
                expect(group.members.count).to eq(1)
            end
        end

        context "when removing" do
            before :each do
                user_group.save
                delete :destroy, group_id: group.id, id: user.id
            end

            it "redirects" do
                expect(response).to redirect_to group_path(group)
            end

            it "removes the user" do
                group.reload
                expect(group.members.count).to eq(0)
            end
        end
    end

    describe 'POST#create' do
        login_user_from_let
        
        context "when unsuccessful" do
            before :each do
                allow_any_instance_of(UserGroup).to receive(:save).and_return(false)
                post :create, group_id: group.id, user: {user_id: add.id}
            end

            it "redirects" do
                expect(response).to render_template :new
            end

            it "flashes" do
                expect(flash[:alert])
            end

            it "doesn't create the user" do
                group.reload
                expect(group.members.count).to eq(0)
            end
        end
        
        context "before creating" do
            it "makes sure group count is 1" do
                user_group.save
                expect(group.members.count).to eq(1)
            end
        end

        context "when creating with survey fields" do
            let(:field){create(:field, field_type: "group_survey", type: "NumericField", container_id: group.id, container_type: "Group", elasticsearch_only: false)}

            before :each do
                user_group.save
                field.save
                post :create, group_id: group.id, user: {user_id: add.id}
            end

            it "redirects" do
                expect(response).to redirect_to survey_group_questions_path(group)
            end

            it "flashes" do
                expect(flash[:notice])
            end

            it "creates the user" do
                group.reload
                expect(group.members.count).to eq(2)
            end
        end

        context "when creating without survey fields" do
            before :each do
                user_group.save
                request.env["HTTP_REFERER"] = "back"
                post :create, group_id: group.id, user: {user_id: add.id}
            end

            it "redirects" do
                expect(response).to redirect_to "back"
            end

            it "flashes" do
                expect(flash[:notice])
            end

            it "creates the user" do
                group.reload
                expect(group.members.count).to eq(2)
            end
        end
    end

    describe 'POST#add_members' do
        login_user_from_let

        let(:user_group2) {create(:user_group, group_id: group.id, user_id: add.id)}

        before :each do
            user_group.save
            user_group2.save
            post :add_members, group_id: group.id, group: {member_ids: [add.id]}
        end

        it "redirects" do
            expect(response).to redirect_to action: 'index'
        end

        it "creates the users" do
            group.reload
            expect(group.members.count).to eq(2)
        end
    end

    describe 'DELETE#remove_member' do
        login_user_from_let

        before :each do
            user_group.save
            delete :remove_member, group_id: group.id, id: user.id
        end

        it "redirects" do
            expect(response).to redirect_to action: 'index'
        end

        it "removes the user" do
            group.reload
            expect(group.members.count).to eq(0)
        end
    end
end
