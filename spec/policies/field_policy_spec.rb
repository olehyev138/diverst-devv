require 'rails_helper'

RSpec.describe FieldPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:annual_budget) { create(:annual_budget, group: group) }
  let(:budget) { create(:budget, annual_budget: annual_budget) }
  let(:no_access) { create(:user) }
  let(:field) { create(:field) }
  let!(:user) { no_access }

  subject { described_class.new(user.reload, field) }


  describe 'for users with access' do
    context 'when manage_all is false' do
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      it 'returns true for #parent_update? assuming the fields parent can update' do
        expect(subject.parent_update?).to eq true
      end
    end
  end
end
