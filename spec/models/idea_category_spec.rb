require 'rails_helper'

RSpec.describe IdeaCategory, type: :model do
  let!(:idea_category) { build_stubbed(:idea_category) }

  it { expect(idea_category).to belong_to(:enterprise) }
  it  { expect(idea_category).to have_many(:answers) }
  
  it { expect(idea_category).to validate_presence_of(:name) }
end
