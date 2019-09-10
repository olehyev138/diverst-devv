require 'rails_helper'

RSpec.describe SegmentGroupScopeRule, type: :model do
  let(:sgcr) { build(:segment_group_scope_rule) }

  it { expect(sgcr).to belong_to(:segment) }
  it { expect(sgcr).to have_many(:segment_group_scope_rule_groups) }
  it { expect(sgcr).to have_many(:groups).through(:segment_group_scope_rule_groups) }

  it { expect(sgcr).to validate_presence_of(:operator) }

  describe '.operators' do
    operators = {
      join: 0,
      intersect: 1
    }
    it { expect(described_class.operators).to eq(operators) }
  end

  describe '#operator_name' do
    it { expect(sgcr.operator_name(0)).to eq(:join) }
    it { expect(sgcr.operator_name(1)).to eq(:intersect) }
  end

  describe '#apply' do
    let!(:enterprise) { create(:enterprise) }
    let!(:groups) { create_list(:group, 2, enterprise: enterprise) }
    let!(:users) { create_list(:user, 2, enterprise: enterprise) }
    let!(:user_group) { create(:user_group, user_id: users.first.id, group_id: groups.first.id) }
    let!(:user_group1) { create(:user_group, user_id: users.last.id, group_id: groups.last.id) }
    let!(:sgcr) { create(:segment_group_scope_rule, segment_id: create(:segment, enterprise_id: enterprise.id).id, operator: 0) }
    let!(:sgcrg) { create(:segment_group_scope_rule_group, segment_group_scope_rule_id: sgcr.id, group_id: groups.first.id) }

    it 'returns uniq users' do
      expect(sgcr.apply(users)).to eq([users.first])
    end

    it 'returns intersection of users' do
      sgcr.update(operator: 1)
      expect(sgcr.apply(users)).to eq([])
    end
  end
end
