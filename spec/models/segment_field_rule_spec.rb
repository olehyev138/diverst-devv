require 'rails_helper'

RSpec.describe SegmentFieldRule, type: :model do
  describe 'when validating' do
    let(:segment_field_rule) { build_stubbed(:segment_field_rule) }

    it { expect(segment_field_rule).to belong_to(:field) }
    it { expect(segment_field_rule).to belong_to(:segment) }

    it { is_expected.to validate_presence_of(:operator) }
    it { is_expected.to validate_presence_of(:field) }
    it { is_expected.to validate_presence_of(:field_id) }
    it { is_expected.to validate_presence_of(:data) }
  end

  describe '#data' do
    it 'allows a length of data over 255 characters' do
      data = '["Atlanta", "BrookwoodBirmAL", "Charlotte-Hearst Tower", "Columbia 1333", "Columbia, SC", "Fort Myers - 4211 Metro Pkwy",
                 "Ft. Lauderdale 401 E Las Olas", "GreensboroNC800Valley", "HallandaleBchFL", "Jacksonville - 76 Laura St", "Lithia Springs GA",
                 "Nashville, TN", "Miami, FL", "Raleigh, NC"]'

      expect(data.length).to eq(328)

      segment_field_rule = build(:segment_field_rule)
      segment_field_rule.data = data
      segment_field_rule.save!

      expect(segment_field_rule.valid?).to be(true)
    end
  end
end
