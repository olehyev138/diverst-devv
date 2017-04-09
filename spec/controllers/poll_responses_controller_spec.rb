require 'rails_helper'

RSpec.describe PollResponsesController, type: :controller do
  let(:user){ create(:user) }
  let(:poll){ create(:poll) }
  login_user_from_let

  describe "POST#create" do
    context "with logged user" do
      context "with valid params" do
        let!(:poll_response){ attributes_for(:poll_response) }

        it "creates a new poll_response" do
          expect{ post :create, poll_id: poll.id, poll_response: poll_response }
            .to change(PollResponse.where(poll: poll, user: user), :count).by(1)
        end

        it "redirects to new action" do
          post :create, poll_id: poll.id, poll_response: poll_response
          expect(response).to redirect_to action: :thank_you, id: PollResponse.last
        end
      end
    end
  end
end
