require 'rails_helper'

RSpec.describe UserRole do
  include ActiveJob::TestHelper

  describe 'test association and validation' do
    let(:user_role) { build_stubbed(:user_role) }

    context 'test associations' do
      it { expect(user_role).to belong_to(:enterprise).inverse_of(:user_roles) }
      it { expect(user_role).to have_one(:policy_group_template).inverse_of(:user_role).dependent(:delete) }
    end

    context 'test validations' do
      it { expect(user_role).to validate_presence_of(:role_name) }
      it { expect(user_role).to validate_length_of(:role_name).is_at_most(191) }
      it { expect(user_role).to validate_presence_of(:role_type) }
      it { expect(user_role).to validate_length_of(:role_type).is_at_most(191) }
      it { expect(user_role).to validate_presence_of(:enterprise) }
      it { expect(user_role).to validate_presence_of(:priority) }
      it { expect(user_role).to validate_presence_of(:policy_group_template).on(:update) }
    end

    context 'test uniqueness' do
      let!(:uniqueness) { create(:user_role) }
      it { expect(uniqueness).to validate_uniqueness_of(:priority).scoped_to(:enterprise_id) }
      it { expect(uniqueness).to validate_uniqueness_of(:role_name).scoped_to(:enterprise_id) }
    end

    context 'test uniqueness default' do
      let!(:uniqueness_default) { create(:user_role) }
      before do
        uniqueness_default.update(default: true)
      end
      it { expect(uniqueness_default).to validate_uniqueness_of(:default).scoped_to(:enterprise_id) }
    end
  end

  describe '#role_name' do
    it 'does not reformat thename' do
      user_role = create(:user_role, role_name: 'Group Leader')
      expect(user_role.role_name).to eq('Group Leader')
    end
  end

  describe '#policy_group_template' do
    it 'creates the default policy_group_template' do
      user_role = create(:user_role, role_name: 'Group Leader')
      expect(user_role.policy_group_template).to_not be(nil)
    end
  end

  describe '#role_types' do
    it 'returns the correct list of roles' do
      expect(UserRole.role_types).to eq(['admin', 'user', 'group'])
    end
  end

  describe '#available_priorities' do
    it 'returns the correct list of available_priorities' do
      expect(UserRole.available_priorities).to eq((1..20).to_a)
    end

    it 'returns the correct list of available_priorities' do
      enterprise =  create(:enterprise)
      array = [2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
      expect(UserRole.available_priorities(enterprise.user_roles.priorities)).to eq(array)
    end
  end

  describe '#can_destroy?' do
    it 'returns false when role is the default' do
      enterprise = create(:enterprise)
      user_role = enterprise.user_roles.where(default: true).first
      expect(user_role.can_destroy?).to be(false)
    end

    it 'returns true when role is not the default' do
      enterprise = create(:enterprise)
      user_role = enterprise.user_roles.where.not(default: true).first
      expect(user_role.can_destroy?).to be(true)
    end
  end

  describe '#reset_user_roles' do
    it 'performs the job' do
      perform_enqueued_jobs do
        allow(ResetUserRoleJob).to receive(:perform_later).and_call_original

        enterprise = create(:enterprise)
        admin = create(:user, enterprise: enterprise, user_role: enterprise.user_roles.where(role_name: 'admin').first)
        expect(admin.user_role.role_name).to eq('admin')

        user_role = admin.enterprise.user_roles.where.not(default: true).first
        expect(user_role.can_destroy?).to be(true)

        # remove the role
        user_role.destroy

        # ensure the job was called
        expect(ResetUserRoleJob).to have_received(:perform_later)

        # ensure the admin's role is now the default
        admin.reload

        expect(admin.user_role.role_name).to eq('user')
      end
    end
  end
end
