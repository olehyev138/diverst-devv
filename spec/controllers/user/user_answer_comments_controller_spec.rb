require 'rails_helper'
require 'spec_helper'

RSpec.describe "User::UserAnswerCommentsController", type: :controller do
  let(:user) { create :user }
  
  login_user_from_let
  
  def setup
    @controller = User::UserAnswerCommentsController.new
  end
  
  before {setup}

  describe 'POST#create' do
    let(:answer){ create(:answer, question: create(:question, campaign: create(:campaign, users: [user]))) }
    let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "campaign_comment", points: 50) }
    
    it "rewards a user with points of this action" do
      expect(user.points).to eq 0

      post :create, user_answer_id: answer.id, answer_comment: { content: "" }

      user.reload
      expect(user.points).to eq 50
    end
  end
end
