require 'rails_helper'

RSpec.describe PollsController, type: :controller do
    include ActiveJob::TestHelper
    
    let(:user) { create(:user) }
    let!(:poll) { create(:poll, status: 0, enterprise: user.enterprise, groups: []) }
    let!(:graph1) { create(:graph, aggregation: create(:field)) }
    let!(:graph2) { create(:graph, aggregation: create(:field)) }

    describe "GET#index" do
        context "with logged user" do
            login_user_from_let
            before { get :index }

            it "gets the index" do
                expect(response).to render_template :index
            end

            it "displays all polls" do
                expect(assigns[:polls]).to eq [poll]
            end
        end

        context "without a logged in user" do
            before { get :index }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#new" do
        context "with logged user" do
            login_user_from_let
            before { get :new }

            it "renders new template" do
                expect(response).to render_template :new
            end

            it "returns a new poll object" do
                expect(assigns[:poll]).to be_a_new(Poll)
            end
        end

        context "without a logged in user" do
            before { get :new }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "POST#create" do
        describe "with logged user" do
            login_user_from_let

            context "with valid params" do
                let(:poll){ attributes_for(:poll) }
                enable_public_activity

                it "creates a new poll" do
                    expect{ post :create, poll: poll }.to change(Poll.where(owner_id: user.id), :count).by(1)
                end

                it "track activity of poll" do
                    perform_enqueued_jobs do
                        expect{ post :create, poll: poll }.to change(PublicActivity::Activity
                        .where(owner_id: user.id, recipient_id: user.enterprise.id, trackable_type: "Poll", key: "poll.create"), :count).by(1)
                    end
                end

                it "redirects to index action" do
                    post :create, poll: poll
                    expect(response).to redirect_to action: :index
                end

                it "flashes a notice message" do
                    post :create, poll: poll
                    expect(flash[:notice]).to eq "Your survey was created"
                end
            end

            context "with invalid params" do
                let(:poll){ attributes_for(:poll, status: nil) }

                it "does not create a new poll" do
                    expect{ post :create, poll: poll }.to change(Poll, :count).by(0)
                end

                it "renders the new action" do
                    post :create, poll: poll
                    expect(response).to render_template :new
                end

                it "flashes an alert message" do
                    post :create, poll: poll
                    expect(flash[:alert]).to eq "Your survey was not created. Please fix the errors"
                end
            end
        end

        describe "without a logged in user" do
            before { post :create, poll: poll }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#show" do
        context "with logged user" do
            login_user_from_let

            before do 
                poll.graphs << graph1
                poll.graphs << graph2
                get :show, id: poll.id
            end

            it "sets a valid poll object" do
                expect(assigns[:poll]).to be_valid
            end

            it "display graphs of a particular poll" do
                expect(assigns[:graphs]).to eq [graph1, graph2]
            end


            it "returns poll responses in a decreasing order of created_at" do
                response1 = create(:poll_response, poll: poll, user: user)
                response2 = create(:poll_response, poll: poll, user: user, created_at: DateTime.now + 1.minute, updated_at: DateTime.now + 1.minute)
                expect(assigns[:responses]).to eq [response2, response1]
            end

            it "render show template" do
                expect(response).to render_template :show
            end
        end

        context "without a logged in user" do
            before { get :show, id: poll.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#edit" do
        context "with logged user" do
            login_user_from_let
            before { get :edit, id: poll.id }

            it "set a valid poll object" do
                expect(assigns[:poll]).to be_valid
            end

            it "render edit template" do
                expect(response).to render_template :edit
            end
        end

        context "without a logged in user" do
            before { get :edit, id: poll.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "PATCH#update" do
        let(:poll){ create(:poll, status: 0, enterprise: user.enterprise, groups: []) }
        let(:group){ create(:group, enterprise: user.enterprise) }
        enable_public_activity

        describe "with logged user" do
            login_user_from_let

            context "with valid params" do
                before { patch :update, id: poll.id, poll: { group_ids: [group.id] } }

                it "updates the poll" do
                    poll.reload
                    expect(poll.groups).to eq [group]
                end

                it "track activity of poll" do
                    perform_enqueued_jobs do
                        expect{ patch :update, id: poll.id, poll: { group_ids: [group.id] } }.to change(PublicActivity::Activity.where(
                             owner_id: user.id, recipient_id: user.enterprise.id, trackable_type:              "Poll", trackable_id: poll.id, key: "poll.update"
                         ),
                                :count).by(1)
                    end
                end

                it "flashes a notice message" do
                    expect(flash[:notice]).to eq "Your survey was updated"
                end

                it "redirects to the updated poll" do
                    expect(response).to redirect_to(poll)
                end
            end

            context "with invalid params" do
                let(:group){ create(:group) }
                before(:each) do
                    patch :update, id: poll.id, poll: { group_ids: [group.id] }
                end

                it "does not update the poll" do
                    poll.reload
                    expect(poll.groups).to eq []
                end

                it "flashes an alert message" do
                    expect(flash[:alert]).to eq "Your survey was not updated. Please fix the errors"
                end

                it "renders the edit action" do
                    expect(response).to render_template :edit
                end
            end
        end

        describe "without a logged in user" do
            before { patch :update, id: poll.id, poll: { group_ids: [group.id] } }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "DELETE#destroy" do
        context "with logged user" do
            login_user_from_let
            enable_public_activity

            it "deletes a poll" do
                expect{delete :destroy, id: poll.id}.to change(Poll, :count).by(-1)
            end

            it "redirect to index action" do
                delete :destroy, id: poll.id
                expect(response).to redirect_to action: :index
            end

            it "tracks delete activity" do
                perform_enqueued_jobs do
                    expect{ delete :destroy, id: poll.id }.to change(PublicActivity::Activity.all, :count).by(1)
                end
            end
        end

        context "without a logged in user" do
            before { delete :destroy, id: poll.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#export_csv" do
        context "with logged user" do
            login_user_from_let
            before { get :export_csv, id: poll.id }
          
            it "gets response in csv format" do
                expect(response.content_type).to eq 'text/csv'
            end

            it 'response includes poll_title as part of csv filename' do 
                expect(response.headers["Content-Disposition"]).to include "#{poll.title}_responses.csv"
            end

            it 'returns file in csv format' do
                expect(response.content_type).to eq 'text/csv'
            end
        end

        context "without a logged in user" do
            before { get :export_csv, id: poll.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
end
