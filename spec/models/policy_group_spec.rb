require 'rails_helper'

RSpec.describe PolicyGroup, type: :model do
  describe '.default_group' do
    context 'within single enterprise' do
      let!(:enterprise) { FactoryGirl.create(:enterprise) }
      let!(:not_default_pg) { FactoryGirl.create(:policy_group, enterprise: enterprise) }

      subject { described_class.default_group(enterprise.id) }

      context 'with default group' do
        let!(:default_group) { FactoryGirl.create(:policy_group, enterprise: enterprise, default_for_enterprise: true) }
        it 'returns default group' do
          expect(subject).to eq default_group
        end
      end

      context 'without default group' do
        it 'returns first group' do
          expect(subject).to eq not_default_pg
        end
      end
    end

    describe 'different enterprises' do
      let!(:enterprise1) { FactoryGirl.create(:enterprise) }
      let!(:enterprise2) { FactoryGirl.create(:enterprise) }
      let!(:e1_policy_group) { FactoryGirl.create(:policy_group, enterprise: enterprise1, default_for_enterprise: true) }
      let!(:e2_policy_group) { FactoryGirl.create(:policy_group, enterprise: enterprise2) }

      it 'do not share default groups' do
        expect(
          described_class.default_group(enterprise1.id)
        ).to eq e1_policy_group

        expect(
          described_class.default_group(enterprise2.id)
        ).to eq e2_policy_group
      end
    end
  end
end
