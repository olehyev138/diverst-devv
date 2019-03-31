require 'rails_helper'

RSpec.describe UserMessagePolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:group_message){ create(:group_message, author: user) }

  subject { UserMessagePolicy.new(user, group_message) }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.group_messages_index = false
    no_access.policy_group.group_messages_create = false
    no_access.policy_group.group_messages_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do 
    context 'with correct permissions for managers' do 
      it { is_expected.to permit_actions([:index, :create, :show, :update, :destroy]) }
    end

    context 'when group_messages_index is false' do 
      before { user.policy_group.update group_messages_index: false }
      it { is_expected.to permit_actions([:index, :show]) }
    end

    context 'allow access to non-managers with certain permissions' do 
      before { user.policy_group.update group_messages_manage: false }
      it { is_expected.to permit_actions([:index, :create, :update]) }
    end
  end

  describe 'for users with no access' do 
    let!(:user) { no_access }
    let!(:group_message) { create(:group_message, author: create(:user)) }

    it { is_expected.to forbid_actions([:index, :create, :show, :update, :destroy]) }
  end
end
