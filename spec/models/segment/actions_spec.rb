require 'rails_helper'

RSpec.describe Segment::Actions, type: :model do
  describe 'base_preloads' do
    let!(:base_preloads) { [:field_rules, :order_rules, :group_rules, field_rules: [:field, { field: [:field_definer] }]] }
    it { expect(Segment.base_preloads).to eq base_preloads }
  end
end
