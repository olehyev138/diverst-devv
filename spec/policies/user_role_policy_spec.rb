require 'rails_helper'

RSpec.describe UserRolePolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:user_role){ create(:user_role) }

  subject { UserRolePolicy.new(user, user_role) }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.users_manage = false
    no_access.policy_group.users_index = false
    no_access.policy_group.save!
  }

  describe 'for user with access' do 
    it { is_expected.to  permit_actions([:index, :create, :update, :destroy]) }
  end

  describe 'for user with no access' do 
    let!(:user) { no_access }

    it { is_expected.to forbid_actions([:index, :create, :update, :destroy]) }
  end
end
