require 'rails_helper'

RSpec.describe Segment::Actions, type: :model do
  describe 'base_preloads' do
    it { expect(Segment.base_preloads.include?(:field_rules)).to eq true }
    it { expect(Segment.base_preloads.include?(:order_rules)).to eq true }
    it { expect(Segment.base_preloads.include?(:group_rules)).to eq true }
    it { expect(Segment.base_preloads.include?({ field_rules: [:field, { field: [:field_definer] }] })).to eq true }
  end
end
