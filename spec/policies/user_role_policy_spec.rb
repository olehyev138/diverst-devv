require 'rails_helper'

RSpec.describe UserRolePolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:user_role){ create(:user_role) }

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.users_manage = false
    no_access.policy_group.users_index = false
    no_access.policy_group.save!
  }

  permissions :index?, :create?, :update?, :destroy? do
    it 'allows access to user with correct permissions' do
      expect(subject).to permit(user, user_role)
    end

    it 'denies access to user with incorrect permissions' do
      expect(subject).to_not permit(no_access, user_role)
    end
  end
end
