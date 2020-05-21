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

  describe '.fields' do
    fields_hash = { sign_in_count: 0, points: 1 }
    it { expect(described_class.fields).to eq(fields_hash) }
  end

  describe '.operators' do
    operators_hash = { ASC: 0, DESC: 1 }
    it { expect(described_class.operators).to eq(operators_hash) }
  end

  describe '#field_name' do
    context 'if field value is 0' do
      before { segment_order_rule.update(field: 0) }

      it { expect(segment_order_rule.field_name).to eq(:sign_in_count) }
    end

    context 'if field value is 1' do
      before { segment_order_rule.update(field: 1) }

      it { expect(segment_order_rule.field_name).to eq(:points) }
    end
  end

  describe '#operator_name' do
    context 'if operator value is 0' do
      before { segment_order_rule.update(operator: 0) }

      it { expect(segment_order_rule.operator_name).to eq(:ASC) }
    end

    context 'if operator value is 1' do
      before { segment_order_rule.update(operator: 1) }

      it { expect(segment_order_rule.operator_name).to eq(:DESC) }
    end
  end
end
