require 'rails_helper'

RSpec.describe SegmentPolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:enterprise_2) {create(:enterprise, :scope_module_enabled => false)}
  let(:no_access) { create(:user, :enterprise => enterprise_2) }
  let(:segment){ create(:segment, enterprise: enterprise) }
  let(:segments){ create_list(:segment, 10, enterprise: enterprise2) }
  let(:policy_scope) { SegmentPolicy::Scope.new(user, Segment).resolve }

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.segments_index = false
    no_access.policy_group.segments_create = false
    no_access.policy_group.segments_manage = false
    no_access.policy_group.save!
  }

  permissions ".scope" do
    it "shows only segments belonging to enterprise" do
      expect(policy_scope).to eq [segment]
    end
  end

  permissions :index?, :create?, :manage?, :update?, :destroy? do
    it "allows access to user with correct permissions" do
      expect(subject).to permit(user, segment)
    end

    it "doesn't allow access to user without correct permissions" do

      expect(subject).to_not permit(no_access, segment)
    end
  end

  permissions :index?, :create? do
    it "allows access to non managers" do
      user.policy_group.segments_manage = false

      expect(subject).to permit(user, segment)
    end
  end

  permissions :index? do
    it "allows access to users with index permissions" do
      user.policy_group.segments_manage = false
      user.policy_group.segments_create = false

      expect(subject).to permit(user, segment)
    end
  end
end
