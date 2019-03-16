require 'rails_helper'

RSpec.describe EnterpriseResourcePolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }

  subject { EnterpriseResourcePolicy.new(user, nil) }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.enterprise_resources_index = false
    no_access.policy_group.enterprise_resources_create = false
    no_access.policy_group.enterprise_resources_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do 
    context 'allow access for all actions' do 
      it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
    end

    context 'allow access for index and create actions' do 
      before { user.policy_group.update enterprise_resources_manage: false }
      it { is_expected.to permit_actions([:index, :create]) }
    end

    context 'allows access to user with index permissions' do 
      before do  
        user.policy_group.enterprise_resources_manage = false
        user.policy_group.enterprise_resources_create = false
      end

      it { is_expected.to permit_action :index }
    end
  end

  describe 'for users with no access' do 
    let!(:user) { no_access }

    it { is_expected.to forbid_actions([:index, :create, :update, :destroy]) }
  end
end
