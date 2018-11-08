require 'rails_helper'

RSpec.describe UserMessagePolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:group_message){ create(:group_message, author: user) }

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.group_messages_index = false
    no_access.policy_group.group_messages_create = false
    no_access.policy_group.group_messages_manage = false
    no_access.policy_group.save!
  }

  permissions :index?, :create?, :manage?, :update? do
    it 'allows access to user with correct permissions' do
      expect(subject).to permit(user, group_message)
    end

    it 'denies access to user with incorrect permissions' do
      expect(subject).to_not permit(no_access, group_message)
    end
  end

  permissions :index?, :create?, :update? do
    it 'allows access to non managers' do
      user.policy_group.group_messages_manage = false

      expect(subject).to permit(user, group_message)
    end
  end

end
