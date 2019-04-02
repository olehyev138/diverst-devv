require 'rails_helper'

RSpec.describe InitiativePolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:group) { create :group, enterprise: user.enterprise }
  let(:outcome) {create :outcome, group_id: group.id}
  let(:pillar) { create :pillar, outcome_id: outcome.id}
  let(:initiative) { create :initiative, pillar: pillar, owner_group: group, owner: user}
  let(:policy_scope) { InitiativePolicy::Scope.new(user, Initiative).resolve }

  subject { described_class.new(user, initiative) }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.initiatives_manage = false
    no_access.policy_group.initiatives_index = false
    no_access.policy_group.initiatives_create = false
    no_access.policy_group.save!

    initiative.group.enterprise_id = user.enterprise.id
  }

  permissions ".scope" do
    it "shows only initiatives belonging to enterprise" do
      expect(policy_scope).to eq [initiative]
    end
  end
  
  describe 'for users with access' do 
    context 'when manage_all is false' do 
      context 'when initiatives_index is true, initiatives_manage and initiatives_create are false and current user IS NOT owner' do 
        before do 
          initiative.owner = create(:user)
          user.policy_group.update initiatives_create: false, initiatives_manage: false, initiatives_index: true
        end

        it { is_expected.to permit_actions([:index, :show]) }
      end

      context 'when initiatives_index and initiatives_manage are false, initiatives_create is true and current user IS NOT owner' do 
        before do 
          initiative.owner = create(:user)
          user.policy_group.update initiatives_create: true, initiatives_index: false, initiatives_manage: false
        end

        it { is_expected.to permit_actions([:index, :show, :create]) }
      end

      context 'when initiatives_manage is true, and initiatives_index and initiatives_create are false and current user IS NOT owner' do  
        before do 
          initiative.owner = create(:user)
          user.policy_group.update initiatives_manage: true, initiatives_index: false, initiatives_create: false
        end

        it { is_expected.to permit_actions([:index, :show, :create, :update, :destroy]) }
      end

      context 'when initiatives_manage, initiatives_create, initiatives_index are false, and current user IS owner' do 
        before { user.policy_group.update initiatives_index: false, initiatives_create: false, initiatives_manage: false }
        it { is_expected.to permit_actions([:update, :destroy]) }
      end
    end

    context 'when manage_all is true' do 
      before { user.policy_group.update manage_all: true }
      context 'when initiatives_index, initiatives_manage, initiatives_create are false and current user IS NOT owner' do 
        before do 
          initiative.owner = create(:user)
          user.policy_group.update initiatives_manage: false, initiatives_create: false, initiatives_index: false
        end

        it { is_expected.to permit_actions([:index, :show, :create, :update, :destroy]) }
      end
    end
  end

  describe 'for users with no access' do 
    before { initiative.owner = create(:user) }
    let!(:user) { no_access }
    it { is_expected.to forbid_actions([:index, :show, :create, :update, :destroy]) }
  end

  describe 'test custom policies' do 
    context '#show_calendar?' do 
      it 'when initiative has no segments' do 
        expect(subject.show_calendar?).to eq true
      end

      it 'when initiative has segments' do 
        initiative.segments << create(:segment, enterprise: enterprise)
        expect(subject.show_calendar?).to eq false
      end

      it 'when initiative shares segments with user' do 
        initiative.segments << segment = create(:segment, enterprise: enterprise)
        user.segments << segment 
        expect(subject.show_calendar?).to eq true
      end
    end

    context '#is_a_pending_member?' do 
      it 'returns true if user is pending member' do 
        expect(subject.is_a_pending_member?)
      end
    end

    context '#is_a_member?' do 
      it 'returns true if user is member' do 
        create(:user_group, user_id: user.id, group_id: group.id)
        expect(subject.is_a_member?).to eq true
      end
    end

    context '#is_a_guest?' do 
      it 'returns true if user is guest' do 
        expect(subject.is_a_guest?).to eq true
      end
    end

    context '#user_is_guest_and_event_is_upcoming?' do 
      before { initiative.update start: DateTime.now.tomorrow, end: DateTime.now.tomorrow >> 2 }
      
      it 'returns true if user is a guest and event is upcoming' do 
        expect(subject.user_is_guest_and_event_is_upcoming?).to eq true
      end
    end

    context '#user_is_guest_and_event_is_ongoing?' do 
      before { initiative.update start: DateTime.now.weeks_ago(1), end: DateTime.now.tomorrow >> 2 }
      
      it 'returns if user is guest and event is ongoing' do 
        expect(subject.user_is_guest_and_event_is_ongoing?).to eq true
      end
    end

    context '#join_leave_button_visibility?' do 
      it 'return false if event is past' do 
        initiative.update start: DateTime.now.weeks_ago(3), end: DateTime.now.weeks_ago(1)
        expect(subject.join_leave_button_visibility?).to eq false
      end

      it 'return true if user is guest and event is ongoing' do 
        initiative.update start: DateTime.now.weeks_ago(1), end: DateTime.now.tomorrow >> 2
        expect(subject.join_leave_button_visibility?).to eq true
      end

      it 'returns true if event is upcoming' do 
        initiative.update start: DateTime.now.tomorrow, end: DateTime.now.tomorrow >> 2
        expect(subject.join_leave_button_visibility?).to eq true
      end
    end
  end
end
