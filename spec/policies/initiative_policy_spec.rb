require 'rails_helper'

RSpec.describe InitiativePolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let(:group) { create :group, enterprise: user.enterprise }
  let(:outcome) {create :outcome, group_id: group.id}
  let(:pillar) { create :pillar, outcome_id: outcome.id}
  let(:initiative) { create :initiative, pillar: pillar, owner_group: group, owner: user}

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.initiatives_manage = false
    no_access.policy_group.initiatives_index = false
    no_access.policy_group.initiatives_create = false
    no_access.policy_group.save!
  }

  permissions :index?, :show?, :create?, :manage?, :update?, :destroy? do

    it "allows access" do
      expect(subject).to permit(user, initiative)
    end

    it "doesn't allow access" do
      expect(subject).to_not permit(no_access, initiative)
    end
  end

  permissions :index?, :show?, :create?, :update?, :destroy? do
    it "allows access when user is not a manager" do
      user.policy_group.initiatives_manage = false

      expect(subject).to permit(user, initiative)
    end
  end

  permissions :index? do
    it 'allows access when only initiatives_index is true' do
      user.policy_group.initiatives_manage = false
      user.policy_group.initiatives_create = false

      expect(subject).to permit(user, initiative)
    end
  end


  permissions :show? do
    let!(:user_2){ create(:user) }

    it "allows access when user is member of group" do
      group = initiative.group
      create(:user_group, :user => user_2, :group => group)

      expect(subject).to permit(user_2, initiative)
    end

    it "allows access when user is member of participating group" do
      participating_group = create(:group, :enterprise => user_2.enterprise)
      create(:user_group, :user => user_2, :group => participating_group)
      initiative.participating_groups << participating_group

      expect(subject).to permit(user_2, initiative)
    end

    it "allows access when initiatives_manage is true" do
      user_2.policy_group.initiatives_manage = true
      user_2.policy_group.save!

      expect(subject).to permit(user_2, initiative)
    end

    it "allows access when user is erg leader" do
      allow(user_2).to receive(:erg_leader?).and_return(true)

      expect(subject).to permit(user_2, initiative)
    end
  end


  permissions :is_a_pending_member? do

    it "doesnt allow access when user isnt a member at all" do
      expect(subject).to_not permit(user, initiative)
    end

    it "doesn't allow access when user is a member but has been accepted" do
      create(:user_group, :user => user, :group => group, :accepted_member => true)

      expect(subject).to_not permit(user, initiative)
    end

    it "allows access" do
      create(:user_group, :user => user, :group => group, :accepted_member => false)

      expect(subject).to permit(user, initiative)
    end
  end

  permissions :is_a_member? do

    it "doesnt allow access" do
      expect(subject).to_not permit(user, initiative)
    end

    it "allows access" do
      create(:user_group, :user => user, :group => group)

      expect(subject).to permit(user, initiative)
    end
  end

  permissions :is_a_guest? do

    it 'allows access for pending members' do
      create(:user_group, :user => user, :group => group, :accepted_member => false)

      expect(subject).to permit(user, initiative)
    end

    it 'allows access for non members' do
      expect(subject).to permit(user, initiative)
    end

    it 'doesnt allow access to members' do
      create(:user_group, :user => user, :group => group)

      expect(subject).to_not permit(user, initiative)
    end

  end

  permissions :user_is_guest_and_event_is_upcoming? do

    it 'doesnt allow access for non guests' do
      create(:user_group, :user => user, :group => group)

      expect(subject).to_not permit(user, initiative)
    end

    it 'doesnt allow access when initiative isnt upcoming' do
      initiative.start = Date.yesterday
      initiative.save!

      expect(subject).to_not permit(user, initiative)
    end

    it 'allows access when initiative is upcoming' do
      initiative.start = Date.tomorrow
      initiative.save!

      expect(subject).to permit(user, initiative)
    end
  end

  permissions :user_is_guest_and_event_is_ongoing? do

    it 'doesnt allow access for non guests' do
      create(:user_group, :user => user, :group => group)

      expect(subject).to_not permit(user, initiative)
    end

    it 'doesnt allow access when initiative isnt ongoing' do
      initiative.start = Date.yesterday
      initiative.end = Date.current
      initiative.save!

      expect(subject).to_not permit(user, initiative)
    end

    it 'allows access when initiative is ongoing' do
      initiative.start = Date.yesterday
      initiative.end = Date.tomorrow
      initiative.save!

      expect(subject).to permit(user, initiative)
    end
  end

  permissions :user_is_guest_and_event_is_ongoing? do

    it 'doesnt allow access for non guests' do
      create(:user_group, :user => user, :group => group)

      expect(subject).to_not permit(user, initiative)
    end

    it 'doesnt allow access when initiative isnt ongoing' do
      initiative.start = Date.yesterday
      initiative.end = Date.current
      initiative.save!

      expect(subject).to_not permit(user, initiative)
    end

    it 'allows access when initiative is ongoing' do
      initiative.start = Date.yesterday
      initiative.end = Date.tomorrow
      initiative.save!

      expect(subject).to permit(user, initiative)
    end
  end


  ## todo: test scope ##
end
