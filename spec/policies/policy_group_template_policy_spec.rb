require 'rails_helper'

RSpec.describe PolicyGroupTemplatePolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:policy_group_template){ create(:policy_group_template) }

  subject { PolicyGroupTemplatePolicy.new(user, policy_group_template) }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.permissions_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do 
    context 'when manage_all is false' do 
      it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
    end

    context 'when manage_all is true and permissions_manage is false' do 
      before { user.policy_group.update permissions_manage: false, manage_all: true }
      it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
    end
  end

  describe 'for users with no access' do 
    let!(:user) { no_access }
    it { is_expected.to forbid_actions([:index, :create, :update, :destroy]) }
  end
end
