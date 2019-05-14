require 'rails_helper'

RSpec.describe SegmentOrderRule, type: :model do
  let(:segment_order_rule) { create(:segment_order_rule) }

  describe 'validations' do
    it { expect(segment_order_rule).to validate_presence_of(:field) }
    it { expect(segment_order_rule).to validate_presence_of(:operator) }
  end

  describe 'associations' do
    it { expect(segment_order_rule).to belong_to(:segment) }
  end
end
