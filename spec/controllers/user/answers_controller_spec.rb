require 'rails_helper'

RSpec.describe User::AnswersController, type: :controller do
  let(:user) { create :user }
  login_user_from_let

  describe 'PUT#vote' do
    let(:answer){ create(:answer, question: create(:question, campaign: create(:campaign, users: [user]))) }
    let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "campaign_vote", points: 70) }

    context "when voting an answer" do
      it "rewards a user with points of this action" do
        expect(user.points).to eq 0

        put :vote, id: answer, answer: { upvoted: "true" }

        user.reload
        expect(user.points).to eq 70
      end
    end
  end

  describe 'POST#create' do
    let(:question){ create(:question, campaign: create(:campaign, enterprise: user.enterprise)) }
    let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "campaign_answer", points: 75) }

    it "rewards a user with points of this action" do
      expect(user.points).to eq 0

      post :create, question_id: question, answer: { content: "" }

      user.reload
      expect(user.points).to eq 75
    end
  end
end
