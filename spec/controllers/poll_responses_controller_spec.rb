require 'rails_helper'

RSpec.describe PollResponsesController, type: :controller do
    let(:user){ create(:user) }
    let(:poll){ create(:poll) }
    let(:poll_response){ create :poll_response, poll: poll}
    login_user_from_let
    
    describe "GET#index", :skip => true do
        context "with logged user" do
            it "gets the index" do
                get :index, poll_id: poll.id
                expect(response).to be_success
            end
        end
    end
    
    describe "GET#new" do
        context "with logged user" do
            it "creates a new poll_response" do
                get :new, poll_id: poll.id
                expect(response).to be_success
            end
        end
    end

    describe "POST#create" do
        context "with logged user" do
            context "with valid params" do
                let!(:poll_response){ attributes_for(:poll_response) }
                let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "survey_response", points: 40) }

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
    end
    
    describe "PATCH#update", :skip => true do
        context "with logged user" do
            context "with valid params" do
                before {patch :update, poll_id: poll.id, id: poll_response.id, poll_response: {anonymous: false}}
                
                it "updates a poll_response" do
                end
            end
        end
    end
    
    describe "DELETE#destroy" do
        context "with logged user" do
            it "deletes the poll_response" do
                delete :destroy, poll_id: poll.id, id: poll_response.id
                expect(response.status).to eq(302)
            end
        end
    end
end
