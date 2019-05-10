require 'rails_helper'

RSpec.describe InitiativeSegment, type: :model do
  describe 'when validating' do
    let(:initiative_segment) { build_stubbed(:initiative_segment) }

    it { expect(initiative_segment).to belong_to(:segment) }
    it { expect(initiative_segment).to belong_to(:initiative) }
  end
end
