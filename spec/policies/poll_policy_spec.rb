require 'rails_helper'

RSpec.describe PollPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise)}
  let(:enterprise_2) {create(:enterprise)}
  let(:no_access) { create(:user, :enterprise => enterprise_2) }
  let(:poll){ create(:poll, status: 0, enterprise: user.enterprise, groups: []) }
  let(:polls){ create_list(:poll, 10, status: 0, enterprise: no_access.enterprise, groups: []) }
  let(:policy_scope) { PollPolicy::Scope.new(user, Poll).resolve }

  subject { described_class }

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

  permissions :index?, :create?, :update?, :destroy? do

    it "allows access" do
      expect(subject).to permit(user, poll)
    end

    it "doesn't allow access" do
      expect(subject).to_not permit(no_access, poll)
    end
  end
end
