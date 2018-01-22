require 'rails_helper'

RSpec.describe Groups::GroupMembersController, type: :controller do
    let(:user) { create :user }
    let(:add) { create :user }
    let(:group) { create(:group, enterprise: user.enterprise) }
    let!(:user_group) {create(:user_group, group_id: group.id, user_id: user.id)}

    describe 'GET#index' do
        context 'with user logged in' do
            let!(:user_group1) {create(:user_group, group_id: group.id, user_id: add.id)}
            let!(:segments) { create_list(:segment, 2, owner: user, enterprise: user.enterprise) }
            login_user_from_let
            before { get :index, group_id: group.id }

            it "renders index template" do
                expect(response).to render_template :index
            end

            it 'get valid group object' do 
                expect(assigns[:group]).to be_valid
            end

            it 'returns members' do 
                expect(assigns[:members]).to eq [user, add]
            end

            it 'returns total_members equals 2' do 
                expect(assigns[:total_members]).to eq 2
            end

            it 'returns 2 segments belonging to group object' do 
                expect(assigns[:segments]).to eq segments
            end
        end

        context 'returns format in json' do
            login_user_from_let
            before { get :index, group_id: group.id, format: :json }

            it 'returns format in json' do
                expect(response.content_type).to eq 'application/json'
            end
        end

        context 'with user not logged in' do 
            before { get :index, group_id: group.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe 'GET#pending' do
        context 'when user is logged in' do
            let!(:user1) { create(:user) }
            let!(:user_group1) {create(:user_group, group_id: group.id, user_id: user1.id, accepted_member: false)}
            login_user_from_let
            before do
                get :pending, group_id: group.id 
            end

            it "render pending template" do
                expect(response).to render_template :pending
            end

            it 'set valid group object' do 
                expect(assigns[:group]).to be_valid
            end

            it 'return 1 pending member' do
                assigns[:group].pending_users = "enabled"
                expect(assigns[:group].pending_members).to eq [user1]
            end
        end

        context 'with user not logged in' do 
            before { get :pending, group_id: group.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe 'POST#accept_pending' do
        describe "with logged in user" do
            login_user_from_let
            before { user_group.save }

            it 'accepts pending member' do 
                post :accept_pending, group_id: group.id, id: user.id
                expect(assigns[:group].members).to include user
            end

            it "redirects to pending action after it accepts the pending member" do
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
        context 'when user is logged in' do 
            login_user_from_let
            before { get :new, group_id: group.id }

            it "renders new template" do
                expect(response).to render_template :new 
            end

            it 'gets a valid group object' do 
                expect(assigns[:group]).to be_valid
            end
        end

        context 'when user is not logged in' do
            before { get :new, group_id: group.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe 'DELETE#destroy' do
        describe 'when user is logged in' do 
            login_user_from_let

            context "before removing" do
                it "makes sure group count is 1" do
                    user_group.save
                    expect(group.members.count).to eq(1)
                end
            end

            context "when removing" do
                before do
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


        describe 'when user is not logged in' do
            before { delete :destroy, group_id: group.id, id: user.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe 'POST#create' do
        context "when unsuccessful" do
            login_user_from_let
            
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
                expect(group.members.count).to eq(1)
            end
        end
        
        context "before creating" do
            login_user_from_let
            
            it "makes sure group count is 1" do
                user_group.save
                expect(group.members.count).to eq(1)
            end

            context "when creating with survey fields" do
                let(:field) {create(:field, field_type: "group_survey", type: "NumericField", container_id: group.id, container_type: "Group", elasticsearch_only: false)}

                before do
                    user_group.save
                    field.save
                    post :create, group_id: group.id, user: {user_id: add.id}
                end

                it "redirects to survey group questions path" do
                    expect(response).to redirect_to survey_group_questions_path(group)
                end

                it "flashes a notice message" do
                    expect(flash[:notice]).to eq 'The member was created'
                end

                it "creates the user" do
                    group.reload
                    expect(group.members.count).to eq(2)
                end
            end

            context "when creating without survey fields" do
                before do
                    user_group.save
                    request.env["HTTP_REFERER"] = "back"
                    post :create, group_id: group.id, user: {user_id: add.id}
                end

                it "redirects to previous page" do
                    expect(response).to redirect_to "back"
                end

                it "flashes a notice message" do
                    expect(flash[:notice]).to eq "The member was created"
                end

                it "creates the user" do
                    group.reload
                    expect(group.members.count).to eq(2)
                end
            end
        end 

        context 'when user is not logged in' do
            before { post :create, group_id: group.id, user: {user_id: add.id} }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe 'POST#add_members' do
        context 'when user is logged in' do 
            login_user_from_let

            let(:user_group2) {create(:user_group, group_id: group.id, user_id: add.id)}

            before do
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

        context 'when user is not logged in' do 
            before { post :add_members, group_id: group.id, user_id: add.id }
            it_behaves_like 'redirect user to users/sign_in path'
        end
    end

    describe 'DELETE#remove_member' do
        context 'when user is logged in' do 
            login_user_from_let

            before do
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

        context 'when user is not logged in' do 
            before { delete :remove_member, group_id: group.id, id: user.id }
            it_behaves_like 'redirect user to users/sign_in path'
        end
    end
end
