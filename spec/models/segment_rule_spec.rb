require 'rails_helper'

RSpec.describe SegmentRule, type: :model do
  describe 'when validating' do
    let(:segment_rule){ build_stubbed(:segment_rule) }

    it{ expect(segment_rule).to belong_to(:segment) }
    it{ expect(segment_rule).to belong_to(:field) }

    it { is_expected.to validate_presence_of(:operator) }
    it { is_expected.to validate_presence_of(:segment) }
    it { is_expected.to validate_presence_of(:field) }
    it { is_expected.to validate_presence_of(:values) }
  end
end
