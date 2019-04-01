require 'rails_helper'

RSpec.describe OutcomePolicy, :type => :policy do

  let(:user){ create(:user) }
  let(:no_access) { create(:user) }
  let(:outcome) { create(:outcome) }

  subject { OutcomePolicy.new(user, outcome) }

  before {
    outcome.group = create(:group, :owner => user, :enterprise_id => user.enterprise_id)

    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.initiatives_index = false
    no_access.policy_group.initiatives_create = false
    no_access.policy_group.initiatives_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do 
    context 'when manage_all is false' do 
      it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
    end

    context 'when manage_all is true and initiatives_manage, initiatives_create, and initiatives_index are false' do 
      before { user.policy_group.update initiatives_create: false, initiatives_index: false, initiatives_manage: false, manage_all: true }
      it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
    end

    context 'when #manage? returns false but current user is owner' do 
      before { user.policy_group.update initiatives_create: false, initiatives_index: false, initiatives_manage: false, manage_all: false }
      it { is_expected.to permit_actions([:update, :destroy]) }
    end

    context 'when ONLY initiatives_index is true and current user is owner' do 
      before { user.policy_group.update initiatives_create: false, initiatives_index: true, initiatives_manage: false, manage_all: false }
      it { is_expected.to permit_actions([:index, :update, :destroy]) }
    end

    context 'when ONLY initiatives_index is true and current user is NOT owner' do 
      before do
        outcome.group.owner = create(:user)
        user.policy_group.update initiatives_create: false, initiatives_index: true, initiatives_manage: false, manage_all: false
      end

      it { is_expected.to permit_action(:index) }
    end

    context 'when ONLY initiatives_create is true and current user is owner' do 
      before { user.policy_group.update initiatives_create: true, initiatives_index: false, initiatives_manage: false, manage_all: false }
      it { is_expected.to permit_actions([:index, :update, :destroy]) }
    end

    context 'when ONLY initiatives_create is true and current user is NOT owner' do 
      before do
        outcome.group.owner = create(:user)
        user.policy_group.update initiatives_create: true, initiatives_index: false, initiatives_manage: false, manage_all: false
      end      

      it { is_expected.to permit_actions([:index, :create]) }
    end
  end

  describe 'for users with no access' do 
    before { outcome.group.owner = create(:user) }
    let!(:user) { no_access }
    it { is_expected.to forbid_actions([:index, :create, :update, :destroy]) }
  end
end
