require 'rails_helper'

RSpec.describe PollResponsesController, type: :controller do
    let(:user){ create(:user) }
    let(:poll){ create(:poll) }
    let(:poll_response){ create :poll_response, poll: poll}

    describe "GET#index", :skip => "MISSING TEMPLATE" do
        context "with logged user" do
            login_user_from_let

            it "gets the index" do
                get :index, poll_id: poll.id
                expect(response).to be_success
            end
        end
    end


    describe "GET#new" do
        context "with logged user" do
            login_user_from_let
            before { get :new, poll_id: poll.id }

            it "render a new template" do
                expect(response).to render_template :new
            end

            it "creates a new poll_response object" do
              expect(assigns[:response]).to be_a_new(PollResponse)
          end
        end

        context "without a logged in user" do
            before { get :new, poll_id: poll.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "POST#create" do
        context "with logged user" do
            login_user_from_let

            context "with valid params" do
                let!(:poll_response) { attributes_for(:poll_response) }
                let!(:reward_action) { create(:reward_action, enterprise: user.enterprise, key: "survey_response", points: 40) }

                it "creates a new poll_response" do
                    expect{ post :create, poll_id: poll.id, poll_response: poll_response }.to change(PollResponse.where(poll: poll, user: user), :count).by(1)
                end

                it "rewards a user with points of this action" do
                    expect(user.points).to eq 0

                    post :create, poll_id: poll.id, poll_response: poll_response

                    user.reload
                    expect(user.points).to eq 40
                end

                it "redirects to new action" do
                    post :create, poll_id: poll.id, poll_response: poll_response
                    expect(response).to redirect_to action: :thank_you, id: PollResponse.last
                end
            end
        end

        context "without a logged in user" do
            let!(:poll_response) { attributes_for(:poll_response) }
            let!(:reward_action) { create(:reward_action, enterprise: user.enterprise, key: "survey_response", points: 40) }
            before { post :create, poll_id: poll.id, poll_response: poll_response }

            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "PATCH#update" do
        context "with valid params" do
            before {patch :update, poll_id: poll.id, id: poll_response.id, poll_response: {anonymous: false}}

            it "updates a poll_response" do
                poll_response.reload
                expect(poll_response.anonymous).to eq false
            end

            it "renders edit template" do
                expect(response).to redirect_to assigns[:poll]
            end
        end
    end

    describe "GET#thank_you" do
        context "with logged in user" do
            login_user_from_let

            before { get :thank_you, poll_id: poll.id, id: poll_response.id }

            it "renders thank_you template" do
                expect(response).to render_template :thank_you
            end
        end

        context "without logged in user" do
            before { get :thank_you, poll_id: poll.id, id: poll_response.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe "DELETE#destroy" do
        context "successfull delete poll response" do
            it "redirect to index action" do
                delete :destroy, poll_id: poll.id, id: poll_response.id
                expect(response.status).to eq(302)
            end

            it "deletes poll response" do
                poll_response
                expect{ delete :destroy, poll_id: poll.id, id: poll_response.id }.to change(PollResponse, :count).by(-1)
            end
        end
    end
end
