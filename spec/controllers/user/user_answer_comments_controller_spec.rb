require 'rails_helper'
require 'spec_helper'

RSpec.describe "User::UserAnswerCommentsController", type: :controller do
  let(:user) { create :user }

  def setup
    @controller = User::UserAnswerCommentsController.new
  end

  before {setup}

  describe 'POST#create' do
    describe "when user is logged in" do
      login_user_from_let

      context "successfully create comment" do 
        let(:answer){ create(:answer, question: create(:question, campaign: create(:campaign, users: [user]))) }
        let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "campaign_comment", points: 50) }

        it "sets comments author to current user" do
          post :create, user_answer_id: answer.id, answer_comment: { content: "blah" }
          expect(assigns[:comment].author).to eq user
        end

        it "rewards a user with points of this action" do
          expect(user.points).to eq 0

          post :create, user_answer_id: answer.id, answer_comment: { content: "blah" }

          user.reload
          expect(user.points).to eq 50
        end
      end
    end
  end
end
