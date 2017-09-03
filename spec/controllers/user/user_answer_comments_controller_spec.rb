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

<<<<<<< HEAD:spec/controllers/user/user_answer_comments_controller_spec.rb
      post :create, user_answer_id: answer.id, answer_comment: { content: "" }
=======
      post :create, answer_id: answer, answer_comment: { content: "comment" }
>>>>>>> 788b5bdb694d972254ad5739a8ed38aa494f3d2e:spec/controllers/user/answer_comments_controller_spec.rb

      user.reload
      expect(user.points).to eq 50
    end
  end
end
