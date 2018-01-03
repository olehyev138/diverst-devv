require 'rails_helper'

RSpec.describe User::UserRewardsController, type: :controller do
  let(:user) { create :user }
  let(:reward) { create(:reward, enterprise: user.enterprise, points: 10) }

  describe "POST#create" do
    describe "with a logged in user" do
      login_user_from_let

      context "with user without credits" do
        it "should redirect to error action" do
          post :create, reward_id: reward

          expect(response).to redirect_to action: :error
        end
      end

      context "with user with credits" do
        it "should redirect to success action" do
          create(:user_reward_action, user: user, operation: "add", points: 20)

          post :create, reward_id: reward

          expect(response).to redirect_to action: :success
        end
      end
    end

    describe "with a user not logged in" do
        before { post :create, reward_id: reward }
        it_behaves_like "redirect user to users/sign_in path"
    end
  end
end
