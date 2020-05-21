require 'rails_helper'
require_dependency "#{::Rails.root}/app/controllers/user/questions_controller"

RSpec.describe User::QuestionsController, type: :controller do
  let!(:user) { create :user }
  let!(:campaign) { create(:campaign, enterprise: user.enterprise, owner: user) }
  let!(:question1) { create(:question, campaign: campaign, created_at: Time.current, updated_at: Time.current) }
  let!(:question2) { create(:question, campaign: campaign, created_at: Time.current + 1.days, updated_at: Time.current + 1.days) }
  let!(:answer1) { create(:answer, question: question1, author: user, upvote_count: 4) }
  let!(:answer2) { create(:answer, question: question1, author: user, upvote_count: 8) }
  let!(:other_answer) { create(:answer, question: question2, author: user) }
  let!(:sponsor1) { create(:sponsor, campaign_id: campaign.id) }
  let!(:sponsor2) { create(:sponsor, campaign_id: campaign.id) }
  let!(:sponsor3) { create(:sponsor, enterprise_id: user.enterprise.id) }

  describe 'GET #index' do
    describe 'when user is logged in' do
      login_user_from_let
      before { get :index, user_campaign_id: campaign.id }

      it 'return success' do
        expect(response).to be_success
      end

      it 'render index template' do
        expect(response).to render_template :index
      end

      it 'return campaign questions in descending order of created_at' do
        expect(assigns[:questions]).to eq [question2, question1]
      end

      it 'return campaign sponsors' do
        expect(assigns[:sponsors]).to eq [sponsor1, sponsor2]
      end
    end

    describe 'when user is not logged in' do
      before { get :index, user_campaign_id: campaign.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'GET #show' do
    describe 'when user is logged in' do
      login_user_from_let
      before { get :show, id: question1.id }

      it 'return success' do
        expect(response).to be_success
      end

      it 'render show template' do
        expect(response).to render_template :show
      end

      it 'return answers to a question1 in descending order of upvote_count' do
        expect(assigns[:answers]).to eq [answer2, answer1]
      end

      it 'returns a new answer object for question1' do
        expect(assigns[:answer]).to be_a_new(Answer)
      end
    end

    describe 'when user is not logged in' do
      before { get :show, id: question1.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
