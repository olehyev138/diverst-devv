require 'rails_helper'

RSpec.describe SegmentRule, type: :model do
  describe 'when validating' do
    let(:segment_rule){ build_stubbed(:segment_rule) }

    it{ expect(segment_rule).to belong_to(:field) }

    it { is_expected.to validate_presence_of(:operator) }
    it { is_expected.to validate_presence_of(:field) }
    #it { is_expected.to validate_presence_of(:values) }
  end

  describe "#values" do
    it "allows a length of values over 255 characters" do
      values = "[\"Atlanta\", \"BrookwoodBirmAL\", \"Charlotte-Hearst Tower\", \"Columbia 1333\", \"Columbia, SC\", \"Fort Myers - 4211 Metro Pkwy\", \"Ft. Lauderdale 401 E Las Olas\", \"GreensboroNC800Valley\", \"HallandaleBchFL\", \"Jacksonville - 76 Laura St\", \"Lithia Springs GA\", \"Ft. Lauderdale 401 E Las Olas\", \"GreensboroNC800Valley\", \"HallandaleBchFL\", \"Jacksonville - 76 Laura St\", \"Lithia Springs GA\", \"Nashville, TN\", \"Miami, FL\", \"Raleigh, NC\"]"
      expect(values.length).to eq(422)

      segment_rule = build(:segment_rule)
      segment_rule.values = values
      segment_rule.save!

      expect(segment_rule.valid?).to be(true)
    end
  end
end
