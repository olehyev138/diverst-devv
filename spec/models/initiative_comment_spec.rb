require 'rails_helper'

RSpec.describe InitiativeComment, type: :model do
  describe 'when validating' do
    let(:initiative_comment) { build_stubbed(:initiative_comment) }

    it { expect(initiative_comment).to belong_to(:user) }
    it { expect(initiative_comment).to belong_to(:initiative) }
    it { expect(initiative_comment).to validate_presence_of(:user) }
    it { expect(initiative_comment).to validate_presence_of(:initiative) }
    it { expect(initiative_comment).to validate_presence_of(:content) }
  end
end
