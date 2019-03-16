require 'rails_helper'

RSpec.describe EnterpriseFolderPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:folder){ create(:folder, :enterprise => enterprise)}

  subject { EnterpriseFolderPolicy.new(user, folder) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.enterprise_resources_index = false
    no_access.policy_group.enterprise_resources_create = false
    no_access.policy_group.enterprise_resources_manage = false
    no_access.policy_group.save!

    user.policy_group.manage_all = false
    user.policy_group.save!
  }

  describe 'for users with access' do 
    context 'when manage_all is false' do 
      it 'ensure manage_all is false' do 
        expect(user.policy_group.manage_all).to be(false)
      end

      context 'allow access to all actions' do 
        it { is_expected.to permit_actions([:index, :create, :edit, :update, :destroy]) }
      end
    end

    context 'when manage_all is true' do 
      before {
        user.policy_group.manage_all = true
        user.policy_group.enterprise_resources_index = false
        user.policy_group.enterprise_resources_create = false
        user.policy_group.enterprise_resources_manage = false
        user.policy_group.save!
      }

      it 'ensure manage_all is true' do 
        expect(user.policy_group.manage_all).to be(true)
      end   

      context 'allow access to all actions' do 
        it { is_expected.to permit_actions([:index, :create, :edit, :update, :destroy]) }
      end
    end
  end

  describe 'for users with no access' do 
    let!(:user) { no_access }
    
    context 'forbid access to actions' do 
      it { is_expected.to forbid_actions([:index, :create, :edit, :update, :destroy]) }
    end
  end
end
