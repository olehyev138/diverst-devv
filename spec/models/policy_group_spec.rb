require 'rails_helper'

RSpec.describe PolicyGroup, type: :model do
  describe 'test associations' do
    let(:policy_group) { build(:policy_group) }
      it { expect(policy_group).to belong_to(:user) }
  end

    describe 'update_all_permissions' do
      it 'sets all permissions to false' do
        policy_group = create(:policy_group)
          policy_group.update_all_permissions

          PolicyGroup.all_permission_fields.each do |field|
            expect(policy_group[field]).to eq(false)
          end
      end

        it 'sets all permissions to true' do
          policy_group = create(:policy_group)
            policy_group.update_all_permissions(true)

            PolicyGroup.all_permission_fields.each do |field|
              expect(policy_group[field]).to eq(true)
            end
        end
    end
end
