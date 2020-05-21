require 'rails_helper'

RSpec.describe SegmentRule, type: :model do
  describe 'when validating' do
    let(:segment_rule) { build_stubbed(:segment_rule) }

    it { expect(segment_rule).to belong_to(:field) }
    it { expect(segment_rule).to belong_to(:segment) }

    it { is_expected.to validate_presence_of(:operator) }
    it { is_expected.to validate_presence_of(:field) }
    # it { is_expected.to validate_presence_of(:values) }

    it { is_expected.to validate_length_of(:values).is_at_most(65535) }
  end

  describe '#values' do
    it 'allows a length of values over 255 characters' do
      values = '["Atlanta", "BrookwoodBirmAL", "Charlotte-Hearst Tower", "Columbia 1333", "Columbia, SC", "Fort Myers - 4211 Metro Pkwy",
                 "Ft. Lauderdale 401 E Las Olas", "GreensboroNC800Valley", "HallandaleBchFL", "Jacksonville - 76 Laura St", "Lithia Springs GA",
                 "Nashville, TN", "Miami, FL", "Raleigh, NC"]'

      expect(values.length).to eq(328)

      segment_rule = build(:segment_rule)
      segment_rule.values = values
      segment_rule.save!

      expect(segment_rule.valid?).to be(true)
    end
  end

  describe '#values_array' do
    it 'returns parsed values' do
      values = '["Atlanta", "BrookwoodBirmAL", "Charlotte-Hearst Tower"]'
      segment_rule = create(:segment_rule, values: values)

      expect(segment_rule.values_array).to eq(JSON.parse(values))
    end
  end

  describe '#followed_by?' do
    it 'returns true if field is nil' do
      segment_rule = build(:segment_rule, field: nil)
      expect(segment_rule.followed_by?(create(:user))).to eq(true)
    end
  end

  describe 'test class methods' do
    describe '.operators should return data of frozen hash' do
      it 'equals: 0' do
        expect(described_class.operators[:equals]).to eq 0
      end

      it 'greater_than: 1' do
        expect(described_class.operators[:greater_than]).to eq 1
      end

      it 'lesser_than: 2' do
        expect(described_class.operators[:lesser_than]).to eq 2
      end

      it 'is_not: 3' do
        expect(described_class.operators[:is_not]).to eq 3
      end

      it 'contains_any_of: 4' do
        expect(described_class.operators[:contains_any_of]).to eq 4
      end

      it 'contains_all_of: 5' do
        expect(described_class.operators[:contains_all_of]).to eq 5
      end

      it 'does_not_contain: 6' do
        expect(described_class.operators[:does_not_contain]).to eq 6
      end
    end

    describe '.operator_text(id) returns stringified keys of the operator hash' do
      it "returns 'equals' when id is 0" do
        expect(described_class.operator_text(0)).to eq 'equals'
      end

      it "returns 'greater than' when id is 1" do
        expect(described_class.operator_text(1)).to eq 'greater than'
      end

      it "returns 'lesser than' when id is 2" do
        expect(described_class.operator_text(2)).to eq 'lesser than'
      end

      it "returns 'is not' when id is 3" do
        expect(described_class.operator_text(3)).to eq 'is not'
      end

      it "returns 'contains any of' when id is 4" do
        expect(described_class.operator_text(4)).to eq 'contains any of'
      end

      it "returns 'contains all of' when id is 5" do
        expect(described_class.operator_text(5)).to eq 'contains all of'
      end

      it "returns 'does not contain' when id is 6" do
        expect(described_class.operator_text(6)).to eq 'does not contain'
      end
    end

    describe '.operators' do
      operators_hash = {
                        equals: 0,
                        greater_than: 1,
                        lesser_than: 2,
                        is_not: 3,
                        contains_any_of: 4,
                        contains_all_of: 5,
                        does_not_contain: 6
                       }.freeze
      it { expect(described_class.operators).to eq(operators_hash) }
    end
  end
end
