require 'rails_helper'

RSpec.describe PollsController, type: :controller do
    let(:user) { create(:user) }
    let!(:poll) { create(:poll, status: 0, enterprise: user.enterprise, groups: []) }
    let!(:graph1) { create(:graph, aggregation: create(:field)) }
    let!(:graph2) { create(:graph, aggregation: nil) }



    describe "GET#index" do
        context "with logged user" do
            login_user_from_let
            before { get :index }

            it "gets the index" do
                expect(response).to render_template :index
            end

            it "displays all polls" do
                expect(assigns[:polls].count).to eq 1
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
        context "with logged user" do
            login_user_from_let

            context "with valid params" do
                let(:poll){ attributes_for(:poll) }
                enable_public_activity

                it "creates a new poll" do
                    expect{ post :create, poll: poll }.to change(Poll.where(owner_id: user.id), :count).by(1)
                end

                it "send a notification of poll" do
                    expect_any_instance_of(Notifiers::PollNotifier).to receive("notify!")
                    post :create, poll: poll
                end

                it "track activity of poll" do
                    expect{ post :create, poll: poll }.to change(PublicActivity::Activity
                                                              .where(owner_id: user.id, recipient_id: user.enterprise.id, trackable_type: "Poll", key: "poll.create"), :count).by(1)
                end

                it "redirects to index action" do
                    post :create, poll: poll
                    expect(response).to redirect_to action: :index
                end

                it "flashes a notice message" do
                    post :create, poll: poll
                    expect(flash[:notice]).to eq "Your survey was created"
                end

                it "send email" do
                    post :create, poll: poll
                    expect(assigns[:poll].email_sent).to eq true
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

        context "without a logged in user" do
            before { post :create, poll: poll }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end



    describe "GET#show" do
        context "with logged user" do
            login_user_from_let
            
            before { get :show, id: poll.id }

            it "sets a valid poll object" do 
                expect(assigns[:poll]).to be_valid
            end

            it "display graphs of a particular poll" do
                graph2.update(field_id: nil, aggregation_id: nil)
                poll.graphs << graph1
                poll.graphs << graph2
                expect(assigns[:poll].graphs.includes(:field, :aggregation)).to eq [graph1]
            end

            it "render show template" do 
                expect(response).to render_template :show
            end
        end
    end

    describe "GET#edit" do
        context "with logged user" do
            login_user_from_let

            it "edit a poll" do
                get :edit, id: poll.id
                expect(response).to be_success
            end
        end
    end

    describe "PATCH#update" do
        context "with logged user" do
            login_user_from_let

            let(:poll){ create(:poll, status: 0, enterprise: user.enterprise, groups: []) }
            let(:group){ create(:group, enterprise: user.enterprise) }
            enable_public_activity

            context "with valid params" do
                before(:each) do
                    patch :update, id: poll.id, poll: { group_ids: [group.id] }
                end

                it "updates the poll" do
                    poll.reload
                    expect(poll.groups).to eq [group]
                end

                it "send a notification of poll" do
                    expect_any_instance_of(Notifiers::PollNotifier).to receive("notify!")
                    patch :update, id: poll.id, poll: { group_ids: [group.id] }
                end

                it "track activity of poll" do
                    expect{ patch :update, id: poll.id, poll: { group_ids: [group.id] } }.to change(PublicActivity::Activity.where(
                                                                                                 owner_id: user.id, recipient_id: user.enterprise.id, trackable_type:              "Poll", trackable_id: poll.id, key: "poll.update"
                                                                                             ),
                                                                                                    :count).by(1)
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

                it "renders the edit action" do
                    expect(response).to render_template :edit
                end
            end
        end
    end

    describe "DELETE#destroy" do
        context "with logged user" do
            login_user_from_let

            it "deletes a poll" do
                delete :destroy, id: poll.id
                expect(response).to redirect_to action: :index
            end
        end
    end

    describe "GET#export_csv" do
        context "with logged user" do
            login_user_from_let

            it "gets a csv file" do
                get :export_csv, id: poll.id
                expect(response).to be_success
            end
        end
    end
end
