require 'rails_helper'

RSpec.feature 'Upvoting in campaigns' do

  let(:user) { create(:user) }
  let!(:campaign) { create(:campaign_filled, enterprise: user.enterprise) }

  before do
    login_as(user, scope: :user)
  end

  context 'user upvotes an answer' do
    scenario 'sees the vote update instantly' do
      visit user_question_path(campaign.questions.first)

      page.first('.counter').click
      visit current_path # Reload the page
      expect(page.first('.counter__number')).to have_content '1' # Check the server-rendered vote count
    end
  end

end