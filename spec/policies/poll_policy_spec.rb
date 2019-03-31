require 'rails_helper'

RSpec.describe PollPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise)}
  let(:enterprise_2) {create(:enterprise)}
  let(:no_access) { create(:user, :enterprise => enterprise_2) }
  let(:poll){ create(:poll, status: 0, enterprise: user.enterprise, groups: []) }
  let(:polls){ create_list(:poll, 10, status: 0, enterprise: no_access.enterprise, groups: []) }
  let(:policy_scope) { PollPolicy::Scope.new(user, Poll).resolve }

  subject { PollPolicy.new(user, poll) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.polls_index = false
    no_access.policy_group.polls_create = false
    no_access.policy_group.polls_manage = false
    no_access.policy_group.save!
  }

  permissions ".scope" do
    it "shows only segments belonging to enterprise" do
      expect(policy_scope).to eq [poll]
    end
  end

  describe 'for users with access' do 
    context 'with correct permissions' do 
      it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
    end

    context 'when only polls_index is true' do 
      before { user.policy_group.update polls_index: true, manage_all: false, polls_create: false, polls_manage: false }
      it { is_expected.to permit_action(:index) }
    end

    context 'when only polls_create is true' do 
      before { user.policy_group.update polls_index: false, manage_all: false, polls_create: true, polls_manage: false }
      it { is_expected.to permit_actions([:index, :create]) }
    end

    context 'when only polls_manage is true' do 
      before { user.policy_group.update polls_index: false, manage_all: false, polls_create: false, polls_manage: true }
      it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
    end

    context 'when owner of poll is current user' do 
      before do 
        user.policy_group.update polls_index: false, manage_all: false, polls_create: false, polls_manage: false
        poll.owner = user
      end
      it { is_expected.to permit_actions([:update, :destroy]) }
    end
  end

  describe 'for users with no access' do 
    context 'with wrong permissions' do 
      let!(:user) { no_access }
      it { is_expected.to forbid_actions([:index, :create, :update, :destroy]) }
    end

    context 'when scope_module_enabled is false' do 
      before { enterprise.update scope_module_enabled: false }
      it { is_expected.to forbid_actions([:index, :create, :update, :destroy]) }
    end
  end
end
