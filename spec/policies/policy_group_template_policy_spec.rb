require 'rails_helper'

RSpec.describe PolicyGroupTemplatePolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:policy_group_template){ create(:policy_group_template) }

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.permissions_manage = false
    no_access.policy_group.save!
  }

  permissions :index?, :create?, :update?, :destroy? do
    it 'allows access to user with correct permissions' do
      expect(subject).to permit(user, policy_group_template)
    end

    it 'denies access to user with incorrect permissions' do
      expect(subject).to_not permit(no_access, policy_group_template)
    end
  end

end
