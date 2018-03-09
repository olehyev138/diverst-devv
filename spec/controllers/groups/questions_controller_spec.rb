require 'rails_helper'

RSpec.describe Groups::QuestionsController, type: :controller do
    let(:user) { create :user }
    let(:group){ create(:group, enterprise: user.enterprise) }

    describe 'GET#index' do
        let!(:user_groups_with_answered_survey) { create_list(:user_group, 3, user: user, group: group, data: Faker::Lorem.sentence) }
        let!(:user_group_without_answered_survey) { create_list(:user_group, 2, user: user, group: group) }

        context 'with logged in user' do
            login_user_from_let
            before { get :index, group_id: group.id }

            it 'returns a valid group object' do
                expect(assigns[:group]).to be_valid
            end

            it 'return 3 user group objects with answered survey' do
                expect(assigns[:answers_count]).to eq 3
            end

            it 'renders index template' do
                expect(response).to render_template :index
            end
        end

        context 'with user not logged in' do
            before { get :index, group_id: group.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe 'GET#survey' do
        describe 'user with logged in' do
            login_user_from_let

            context "with no user group" do
                before {get :survey, group_id: group.id}

                it "redirects to group" do
                    expect(response).to redirect_to(group)
                end

                it "flashes a notice message" do
                    expect(flash[:notice]).to eq("Your have to join group before taking it's survey")
                end
            end

            context 'with user group' do
                let!(:user_groups_with_answered_survey) { create_list(:user_group, 3, user: user, group: group, data: Faker::Lorem.sentence) }

                it "renders survey template" do
                   get :survey, group_id: group.id
                   expect(response).to render_template :survey
                end
            end
        end

        describe 'user not logged in' do
            before { get :survey, group_id: group.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe 'POST#submit_survey' do
        describe 'user logged in' do
            login_user_from_let
            let!(:user_groups_with_answered_survey) { create_list(:user_group, 3, user: user, group: group) }

            context "when successful" do
                before do
                    patch :submit_survey, group_id: group.id, "custom-fields": {}
                end

                it "redirects" do
                    expect(response).to redirect_to(group)
                end

                it "flashes" do
                    expect(flash[:notice]).to eq("Your response was saved")
                end
            end

            context "when unsuccessful" do
                before do
                    allow_any_instance_of(UserGroup).to receive(:save).and_return(false)
                    patch :submit_survey, group_id: group.id, "custom-fields": {}
                end

                it "redirects" do
                    expect(response).to redirect_to(group)
                end

                it "flashes" do
                    expect(flash[:alert]).to eq("Your response was not saved")
                end
            end
        end

        describe 'user not logged in' do
            before { patch :submit_survey, group_id: group.id, "custom-fields": {} }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe 'GET#export_csv' do
        describe 'user logged in' do
            login_user_from_let
            before { get :export_csv, group_id: group.id, format: :csv }

            it 'returns format in csv' do
                expect(response.content_type).to eq 'text/csv'
            end
        end

        describe 'user not logged in' do
            before { get :export_csv, group_id: group.id, format: :csv }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
end