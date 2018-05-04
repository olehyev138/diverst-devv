require 'rails_helper'

RSpec.describe View, type: :model do
  let(:view) { FactoryGirl.create :view }

  describe 'factory' do
    it 'is valid' do
      expect(view).to be_valid
    end
  end

  describe 'associations' do
    it { expect(view).to belong_to(:group_message) }
    it { expect(view).to belong_to(:news_link) }
    it { expect(view).to belong_to(:social_link) }
  end
end
