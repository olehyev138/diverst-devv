require 'rails_helper'

RSpec.describe SegmentsController, type: :controller do
    include ApplicationHelper

    let(:enterprise) { create(:enterprise, cdo_name: "test") }
    let(:user) { create(:user, enterprise: enterprise) }
    let!(:segment) { create(:segment, enterprise: enterprise) }


    describe "GET#index" do
        context 'when user is logged in' do
            login_user_from_let
            before { get :index }

            it "render index template" do
                expect(response).to render_template :index
            end

            it "returns list of segments" do
                expect(assigns[:segments]).to eq [segment]
            end
        end

        context 'when user is not logged in' do
            before { get :index }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "GET#new" do
        context 'when user is logged in' do
            login_user_from_let
            before { get :new }

            it "render new template" do
                expect(response).to render_template :new
            end

            it "returns new segement object" do
                expect(assigns[:segment]).to be_a_new(Segment)
            end
        end

        context 'when user is not logged in' do
            before { get :new }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "POST#create" do
        describe 'when user is logged in' do
            login_user_from_let

            context "successfully create" do
                let!(:segment_attributes) { FactoryGirl.attributes_for(:segment) }

                it "redirects" do
                    post :create, :segment => segment_attributes
                    expect(response).to redirect_to action: :index
                end

                it "creates segment" do
                    expect{ post :create, :segment => segment_attributes }.to change(Segment, :count).by(1)
                end

                it "flashes a notice message" do
                    post :create, :segment => segment_attributes
                    expect(flash[:notice]).to eq "Your #{c_t(:segment)} was created"
                end
            end

            context "unsuccessful create" do
                let!(:invalid_segment_attributes) { { name: nil } }
                before { post :create, :segment => invalid_segment_attributes }

                it "flashes an alert message" do
                    expect(flash[:alert]).to eq "Your #{c_t(:segment)} was not created. Please fix the errors"
                end

                it "renders edit template" do
                    expect(response).to render_template :edit
                end
            end
        end

        describe 'when user is not logged in' do
            let!(:segment_attributes) { FactoryGirl.attributes_for(:segment) }
            before { post :create, :segment => segment_attributes }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "GET#show" do
        describe 'when user is logged in' do
            let!(:groups) { create_list(:group, 2, enterprise: enterprise) }
            let!(:user1) { create(:user) }
            let!(:user2) { create(:user) }
            let!(:user3) { create(:user) }
            let!(:users_segment1) { create(:users_segment, segment: segment, user: user1) }
            let!(:users_segment2) { create(:users_segment, segment: segment, user: user2) }
            let!(:users_segment3) { create(:users_segment, segment: segment, user: user3) }
            let!(:user_group1) { create(:user_group, group: groups.last, user: user1) }
            let!(:user_group2) { create(:user_group, group: groups.last, user: user2) }
            login_user_from_let


            context 'when group is present' do
                before do
                    segment.sub_segments << create_list(:segment, 2, enterprise: enterprise, owner: user)
                    get :show, :id => segment.id, group_id: groups.last.id
                end

                it 'render show template' do
                    expect(response).to render_template :show
                end

                it 'return group from group_id' do
                    expect(assigns[:group]).to eq groups.last
                end

                it 'returns 2 segment_members_of_group' do
                    expect(assigns[:members].count).to eq 2
                end

                it 'return groups that belong to user.enterprise' do
                    expect(assigns[:groups]).to eq groups
                end

                it 'return 2 sub_segments of segment' do
                    expect(assigns[:segments]).to eq segment.sub_segments
                end
            end

            context 'when group is not present' do
                before { get :show, :id => segment.id }

                it 'returns 3 uniq members of a segment' do
                    expect(assigns[:members].count).to eq 3
                end
            end
        end

        describe 'when user is not logged in' do
            before { get :show, :id => segment.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "GET#edit" do
        context 'when user is logged in' do
            login_user_from_let
            before { get :edit, :id => segment.id }

            it "render edit template" do
                expect(response).to render_template :edit
            end

            it "returns a valid segment" do
                expect(assigns[:segment]).to be_valid
            end
        end

        context 'when user is not logged in' do
            before { get :edit, :id => segment.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "PATCH#update" do
        describe 'when user is logged in' do
            login_user_from_let

            context "successfully" do
                before { patch :update, :id => segment.id, :segment => {:name => "updated"} }

                it "redirects to segment show page" do
                    expect(response).to redirect_to(segment)
                end

                it "updates a segment" do
                    segment.reload
                    expect(segment.name).to eq("updated")
                end

                it "flashes a notice message" do
                    expect(flash[:notice]).to eq "Your #{c_t(:segment)} was updated"
                end
            end

            context "unsuccessfully" do
                before { patch :update, :id => segment.id, :segment => {:name => nil} }

                it "flashes an alert message" do
                    expect(flash[:alert]).to eq "Your #{c_t(:segment)} was not updated. Please fix the errors"
                end

                it "render edit template" do
                    expect(response).to render_template :edit
                end
            end
        end

        describe 'when user is not logged in' do
            before { patch :update, :id => segment.id, :segment => { :name => "updated" } }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "DELETE#destroy" do
        context 'when user is logged in' do
            login_user_from_let

            it "deletes segment" do
                expect{ delete :destroy, :id => segment.id }.to change(Segment, :count).by(-1)
            end

            it "redirect to action index" do
                delete :destroy, :id => segment.id
                expect(response).to redirect_to action: :index
            end
        end

        context 'when user is not logged in' do
            before { delete :destroy, :id => segment.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "GET#export_csv" do
        context 'when user is logged in' do
            login_user_from_let

            it 'sets a valid segment object' do
                get :export_csv, :id => segment.id, format: :csv
                expect(assigns[:segment]).to be_valid
            end

            it "returns data in csv format" do
                get :export_csv, :id => segment.id, format: :csv
                expect(response.content_type).to eq "text/csv"
            end

            context "when group_id is present in params" do
                let!(:group) { create(:group, :enterprise => enterprise) }
                let!(:user1) { create(:user) }
                let!(:user2) { create(:user) }
                let!(:user3) { create(:user) }
                let!(:users_segment1) { create(:users_segment, segment: segment, user: user1) }
                let!(:users_segment2) { create(:users_segment, segment: segment, user: user2) }
                let!(:users_segment3) { create(:users_segment, segment: segment, user: user3) }
                let!(:user_group1) { create(:user_group, group: group, user: user1) }
                let!(:user_group2) { create(:user_group, group: group, user: user2) }


                before { get :export_csv, :id => segment.id, format: :csv, :group_id => group.id }

                it 'find by id group object passed as group_id in params' do
                    expect(assigns[:current_user].enterprise.groups.find_by_id(controller.params[:group_id])).to eq group
                end

                it 'returns users' do
                    users_ids = segment_members_of_group(segment, group) #helper method in ApplicationHelper
                    users = User.where(id: [users_ids])
                    expect(users.count).to eq 2
                end

                it 'returns filename of segment in csv format' do
                    expect(response.headers["Content-Disposition"]).to include "#{assigns[:segment].name}.csv"
                end
            end

            context 'when group_id is not present in params' do
                let!(:user1) { create(:user) }
                let!(:user2) { create(:user) }
                let!(:user3) { create(:user) }
                let!(:users_segment1) { create(:users_segment, segment: segment, user: user1) }
                let!(:users_segment2) { create(:users_segment, segment: segment, user: user2) }
                let!(:users_segment3) { create(:users_segment, segment: segment, user: user3) }

                before { get :export_csv, :id => segment.id, format: :csv }

                it 'members of segment' do
                    users = assigns[:segment].members
                    expect(users.count).to eq 3
                end
            end
        end

        context 'when user is not logged in' do
            before { get :export_csv, :id => segment.id, format: :csv }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
end
