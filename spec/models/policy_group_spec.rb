require 'rails_helper'

RSpec.describe PolicyGroup, type: :model do
  describe 'test associations' do
    let!(:user) { create(:user) }
    let(:policy_group) { user.policy_group }

    it { expect(policy_group).to belong_to(:user).inverse_of(:policy_group) }
    it { expect(policy_group).to validate_uniqueness_of(:user_id) }
  end

  describe '.update_all_permissions' do
    let!(:user) { create(:user) }
    let(:policy_group) { user.policy_group }

    it 'sets all permissions to false' do
      policy_group.update_all_permissions

      PolicyGroup.all_permission_fields.each do |field|
        expect(policy_group[field]).to eq(false)
      end
    end

    it 'sets all permissions to true' do
      policy_group.update_all_permissions(true)

      PolicyGroup.all_permission_fields.each do |field|
        expect(policy_group[field]).to eq(true)
      end
    end
  end

  describe '.users_that_able_to_accept_budgets' do
    let!(:user) { create(:user) }

    it 'returns users with budget approval permissions' do
      user.policy_group.update(budget_approval: true)
      expect(described_class.users_that_able_to_accept_budgets(user.enterprise)).to eq [user]
    end
  end

  describe '.all_permission_fields' do
    it 'returns all permissions fields' do
      expect(described_class.all_permission_fields).not_to be_empty
    end
  end
end
